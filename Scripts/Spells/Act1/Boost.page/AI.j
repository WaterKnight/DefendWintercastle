//! runtextmacro BaseStruct("AIBoost", "A_I_BOOST")
    eventMethod Event
        call Unit.GetFromId(params.GetSubjectId()).Order.ImmediateBySpell(Boost.THIS_SPELL)
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AICastSpell.CreateBasics(Boost.THIS_SPELL, function thistype.Event)

        call whichCombination.Events.Create(UNIT.Attack.Events.Acquire2.DUMMY_EVENT_TYPE, EventPriority.AI, NULL)
    endmethod
endstruct