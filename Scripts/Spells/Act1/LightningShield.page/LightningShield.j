//! runtextmacro BaseStruct("LightningShield", "LIGHTNING_SHIELD")
    static real DAMAGE_PER_INTERVAL
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Timer intervalTimer
    Unit target

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this.target

        set Unit.TEMP = target

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange * target.Outpact.Z.Get(true) / UNIT_TYPE.Outpact.Z.STANDARD, thistype.TARGET_FILTER)

        local Unit damageTarget = thistype.ENUM_GROUP.FetchFirst()

        if (damageTarget != NULL) then
            loop
                call target.DamageUnitBySpell(damageTarget, thistype.DAMAGE_PER_INTERVAL, true, false)

                set damageTarget = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (damageTarget == NULL)
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

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.intervalTimer = intervalTimer
        set this.target = target
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTarget().Buffs.Timed.Start(thistype.DUMMY_BUFF, params.Spell.GetLevel(), thistype.DURATION)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.DAMAGE_PER_INTERVAL = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct