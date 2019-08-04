//! runtextmacro BaseStruct("AIMedipack", "A_I_MEDIPACK")
    eventMethod Event
        call Unit.GetFromId(params.GetSubjectId()).Order.ImmediateBySpell(Medipack.THIS_SPELL)
    endmethod

    condEventMethod Event_StartConditions
        local Unit caster = Unit.GetFromId(params.GetSubjectId())

        if (caster.Life.Get() >= Real.ToInt(UnitType.ASSASSIN.Life.Get() - Medipack.HEAL)) then
            return false
        endif

        return true
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AICastSpell.CreateBasics(Medipack.THIS_SPELL, function thistype.Event)

        call whichCombination.Pairs.CreateLimit(UNIT.Life.DUMMY_EVENT_TYPE, Real.ToInt(UnitType.ASSASSIN.Life.Get() - Medipack.HEAL), LESS_THAN, BoolExpr.GetFromFunction(function thistype.Event_StartConditions))
    endmethod
endstruct