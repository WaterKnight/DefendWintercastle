//! runtextmacro BaseStruct("AIPalingenesis", "A_I_PALINGENESIS")
    eventMethod Event
        call Unit.GetFromId(params.GetSubjectId()).Order.ImmediateBySpell(Palingenesis.THIS_SPELL)
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AIAutoCast.CreateBasics(Palingenesis.THIS_SPELL, function thistype.Event)

        call whichCombination.Periodic.Add(1.)
    endmethod
endstruct