//! runtextmacro BaseStruct("AIMedipack", "A_I_MEDIPACK")
    static method Event takes nothing returns nothing
        call Unit.GetFromId(Event.GetSubjectId()).Order.ImmediateBySpell(Medipack.THIS_SPELL)
    endmethod

    static method Event_StartConditions takes nothing returns boolean
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())

        if (caster.Life.Get() >= Real.ToInt(UnitType.ASSASSIN.Life.Get() - Medipack.HEAL)) then
            return false
        endif

        return true
    endmethod

    static method Init takes nothing returns nothing
        local EventCombination whichCombination = AICastSpell.CreateBasics(Medipack.THIS_SPELL, function thistype.Event)

        call whichCombination.Pairs.CreateLimit(UNIT.Life.DUMMY_EVENT_TYPE, Real.ToInt(UnitType.ASSASSIN.Life.Get() - Medipack.HEAL), LESS_THAN, BoolExpr.GetFromFunction(function thistype.Event_StartConditions))
    endmethod
endstruct