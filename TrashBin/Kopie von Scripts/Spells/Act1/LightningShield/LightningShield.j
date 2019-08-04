//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("LightningShield", "LIGHTNING_SHIELD")
    static real DAMAGE_PER_INTERVAL
    static real DAMAGE_PER_SECOND
    static Buff DUMMY_BUFF
    static real DURATION
    static Group ENUM_GROUP
    static real INTERVAL
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    real areaRange
    Timer intervalTimer
    Unit target

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local Unit damageTarget
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this.target

        set Unit.TEMP = target

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange * target.Outpact.Z.Get(true) / UNIT_TYPE.Outpact.Z.STANDARD, thistype.TARGET_FILTER)

        set damageTarget = thistype.ENUM_GROUP.FetchFirst()

        if (damageTarget != NULL) then
            loop
                call target.DamageUnitBySpell(damageTarget, thistype.DAMAGE_PER_INTERVAL, true, false)

                set damageTarget = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (damageTarget == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.intervalTimer = intervalTimer
        set this.target = target
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTarget().Buffs.Timed.Start(thistype.DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_LightningShield.j

        set thistype.DAMAGE_PER_INTERVAL = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "LiS", "Lightning Shield", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp", "An electrically charged shield is surround this unit. Nearby entities take damage.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct