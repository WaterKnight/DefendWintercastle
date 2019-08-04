//! runtextmacro BaseStruct("AIPurge", "A_I_PURGE")
    static constant real AREA_RANGE = 500.
    static BoolExpr TARGET_FILTER

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if ((filterUnit.Life.Get() > filterUnit.MaxLife.GetAll()) and (filterUnit.Buffs.CountVisibleEx(false, true) == 0)) then
            return false
        endif

        if (filterUnit.Buffs.Contains(Purge.DUMMY_BUFF)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Event takes nothing returns nothing
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())
        local Unit target

        if (caster.Classes.Contains(UnitClass.DEAD)) then
            return
        endif

        set User.TEMP = caster.Owner.Get()

        set target = GROUP.EnumUnits.InRange.WithCollision.GetRandom(caster.Position.X.Get(), caster.Position.Y.Get(), AREA_RANGE, TARGET_FILTER)

        if (target != NULL) then
            call caster.Order.UnitTargetBySpell(Purge.THIS_SPELL, target)
        endif
    endmethod

    static method Init takes nothing returns nothing
        local EventCombination whichCombination = AICastSpell.CreateBasics(Purge.THIS_SPELL, function thistype.Event)

        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call whichCombination.Events.Create(UNIT.Attack.Events.Acquire2.DUMMY_EVENT_TYPE, EventPriority.AI, NULL)
    endmethod
endstruct