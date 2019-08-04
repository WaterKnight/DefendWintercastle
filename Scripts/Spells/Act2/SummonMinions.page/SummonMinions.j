//! runtextmacro BaseStruct("SummonMinions", "SUMMON_MINIONS")
    static real INTERVAL
    static UnitTypePool SUMMON_UNIT_TYPE_POOL

    Timer intervalTimer
    integer level

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real angle = Math.RandomAngle()
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real x = casterX - thistype.OFFSET * Math.Cos(angle)
        local real y = casterY - thistype.OFFSET * Math.Sin(angle)

		local integer iteration = thistype.SUMMONS_AMOUNT_PER_INTERVAL

        loop
            exitwhen (iteration < 1)

            local UnitType whichUnitType = thistype.SUMMON_UNIT_TYPE_POOL.Random()

            local Unit newUnit = Unit.CreateSummon(whichUnitType, casterOwner, x, y, angle, thistype.SUMMON_DURATION)

            call newUnit.VertexColor.Subtract(0., 0., 0., whichUnitType.VertexColor.Alpha.Get())

            call newUnit.VertexColor.Timed.Add(0., 0., 0., whichUnitType.VertexColor.Alpha.Get(), 1.)

            set iteration = iteration - 1
        endloop
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local thistype this = caster

		local Timer intervalTimer = Timer.Create()

        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    eventMethod Event_EndCast
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Act2
        set thistype.INTERVAL = thistype.THIS_SPELL.GetChannelTime(1) / thistype.INTERVALS_AMOUNT - 0.01
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        set thistype.SUMMON_UNIT_TYPE_POOL = UnitTypePool.Create()

        call thistype.SUMMON_UNIT_TYPE_POOL.AddType(UnitType.AXE_FIGHTER, thistype.SUMMON_UNIT_TYPE_CHANCE)
        call thistype.SUMMON_UNIT_TYPE_POOL.AddType(UnitType.SPEAR_SCOUT, thistype.SUMMON_UNIT_TYPE2_CHANCE)
    endmethod
endstruct