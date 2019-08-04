//! runtextmacro Spell_OpenScope("/")

//! runtextmacro Folder("FireWater")
    //! runtextmacro Struct("Buff")
        static real DAMAGE
        static real DAMAGE_PER_SECOND
        static Buff DUMMY_BUFF
        static real DURATION
        static Group ENUM_GROUP
        static real INTERVAL
        static BoolExpr TARGET_FILTER

        real areaRange
        Timer intervalTimer

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
        endmethod

        static method Conditions takes nothing returns boolean
            local Unit target = UNIT.Event.Native.GetFilter()

            if (target.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (target.Classes.Contains(UnitClass.STRUCTURE)) then
                return false
            endif
            if (target.IsAllyOf(User.TEMP)) then
                return false
            endif
            if (target.MagicImmunity.Try()) then
                return false
            endif

            return true
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()
            local Unit victim

            local Unit target = this

            set User.TEMP = target.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

            set victim = thistype.ENUM_GROUP.FetchFirst()

            if (victim != NULL) then
                loop
                    call target.DamageUnitBySpell(victim, DAMAGE, true, false)

                    set victim = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (victim == NULL)
                endloop
            endif
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Timer intervalTimer = Timer.Create()
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.areaRange = FireWater.THIS_SPELL.GetAreaRange(level)
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            //! import obj_FireWater_Buff.j

            set thistype.DAMAGE = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "FiW", "Fire Water", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNGreaterInvulneralbility.blp", "Damages nearby enemies periodically.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedTarget.mdl", AttachPoint.CHEST, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FireWater", "FIRE_WATER")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static real REFRESHED_MANA

    static Spell THIS_SPELL

    //! runtextmacro LinkToStruct("FireWater", "Buff")

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
        call caster.HealManaBySpell(caster, thistype.REFRESHED_MANA)

        call thistype(NULL).Buff.Start(level, caster)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_FireWater.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct