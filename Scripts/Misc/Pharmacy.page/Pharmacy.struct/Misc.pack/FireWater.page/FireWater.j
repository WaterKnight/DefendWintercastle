//! runtextmacro Folder("FireWater")
    //! runtextmacro Struct("Buff")
        static real DAMAGE
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        real areaRange
        Timer intervalTimer

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.Classes.Contains(UnitClass.STRUCTURE) then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif
            if target.MagicImmunity.Try() then
                return false
            endif

            return true
        endmethod

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            set User.TEMP = target.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

            local Unit victim = thistype.ENUM_GROUP.FetchFirst()

            if (victim != NULL) then
                loop
                    call target.DamageUnitBySpell(victim, DAMAGE, true, false)

                    set victim = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (victim == NULL)
                endloop
            endif
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer intervalTimer = Timer.Create()

            set this.areaRange = FireWater.THIS_SPELL.GetAreaRange(level)
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FireWater", "FIRE_WATER")
    //! runtextmacro LinkToStruct("FireWater", "Buff")

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
        call caster.HealManaBySpell(caster, thistype.REFRESHED_MANA)

        call thistype(NULL).Buff.Start(level, caster)
    endmethod

    initMethod Init of Items_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct