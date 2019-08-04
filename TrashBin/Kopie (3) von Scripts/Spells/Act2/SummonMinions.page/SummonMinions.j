//! runtextmacro BaseStruct("SummonMinions", "SUMMON_MINIONS")
    static real INTERVAL
    static UnitTypePool SUMMON_UNIT_TYPE_POOL

    Timer intervalTimer
    integer level

    static method Interval takes nothing returns nothing
        local integer iteration = thistype.SUMMONS_AMOUNT_PER_INTERVAL
        local Unit newUnit
        local thistype this = Timer.GetExpired().GetData()
        local UnitType whichUnitType

        local Unit caster = this

        local real angle = Math.RandomAngle()
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real x = casterX - thistype.OFFSET * Math.Cos(angle)
        local real y = casterY - thistype.OFFSET * Math.Sin(angle)

        loop
            exitwhen (iteration < 1)

            set whichUnitType = thistype.SUMMON_UNIT_TYPE_POOL.Random()

            set newUnit = Unit.CreateSummon(whichUnitType, casterOwner, x, y, angle, thistype.SUMMON_DURATION)

            call newUnit.VertexColor.Set(whichUnitType.VertexColor.Red.Get(), whichUnitType.VertexColor.Green.Get(), whichUnitType.VertexColor.Blue.Get(), 0.)

            call newUnit.VertexColor.Timed.Add(0., 0., 0., whichUnitType.VertexColor.Alpha.Get(), 1.)

            set iteration = iteration - 1
        endloop
    endmethod

    static method Event_EndCast takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local thistype this = caster

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()

        local thistype this = caster

        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.INTERVAL = thistype.THIS_SPELL.GetChannelTime(1) / thistype.INTERVALS_AMOUNT - 0.01
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.SUMMON_UNIT_TYPE_POOL = UnitTypePool.Create()

            call thistype.SUMMON_UNIT_TYPE_POOL.AddType(thistype.SUMMON_UNIT_TYPE, thistype.SUMMON_UNIT_TYPE_CHANCE)
            call thistype.SUMMON_UNIT_TYPE_POOL.AddType(thistype.SUMMON_UNIT_TYPE2, thistype.SUMMON_UNIT_TYPE2_CHANCE)
    endmethod
endstruct