//! runtextmacro BaseStruct("Boost", "BOOST")
    real criticalAdd
    real speedAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real criticalAdd = this.criticalAdd
        local real speedAdd = this.speedAdd

        call target.CriticalChance.Bonus.Subtract(criticalAdd)
        call target.Movement.Speed.BonusA.Subtract(speedAdd)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real criticalAdd = thistype.CRITICAL_INCREMENT
        local real speedAdd = thistype.SPEED_INCREMENT
        local thistype this = target

        set this.criticalAdd = criticalAdd
        set this.speedAdd = speedAdd

        call target.CriticalChance.Bonus.Add(criticalAdd)
        call target.Movement.Speed.BonusA.Add(speedAdd)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local integer level = SPELL.Event.GetLevel()

        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct