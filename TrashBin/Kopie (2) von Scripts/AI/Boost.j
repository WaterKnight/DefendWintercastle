//! runtextmacro BaseStruct("AIBoost", "A_I_BOOST")
    static method Event takes nothing returns nothing
        call Unit.GetFromId(Event.GetSubjectId()).Order.ImmediateBySpell(Boost.THIS_SPELL)
    endmethod

    static method Init takes nothing returns nothing
        local EventCombination whichCombination = AICastSpell.CreateBasics(Boost.THIS_SPELL, function thistype.Event)

        call whichCombination.Events.Create(UNIT.Attack.Events.Acquire2.DUMMY_EVENT_TYPE, EventPriority.AI, NULL)
    endmethod
endstruct