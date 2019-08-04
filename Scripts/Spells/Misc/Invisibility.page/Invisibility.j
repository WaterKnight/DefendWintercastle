//! runtextmacro BaseStruct("Invisibility", "INVISIBILITY")
    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Invisibility.Subtract()
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Invisibility.Add()
//        call UnitShareVision(target.self, User.ALL[0].self, true)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Misc
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct