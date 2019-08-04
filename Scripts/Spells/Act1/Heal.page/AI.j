//! runtextmacro BaseStruct("AIHeal", "A_I_HEAL")
    static constant real AREA_RANGE = 500.
    static BoolExpr TARGET_FILTER

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if not target.IsAllyOf(User.TEMP) then
            return false
        endif
        if (target.Life.Get() >= Real.ToInt(target.MaxLife.Get()) - Heal.HEAL) then
            return false
        endif

        return true
    endmethod

    eventMethod Event
        local Unit caster = Unit.GetFromId(params.GetSubjectId())

        if caster.Classes.Contains(UnitClass.DEAD) then
            return
        endif

        set User.TEMP = caster.Owner.Get()

        local Unit target = GROUP.EnumUnits.InRange.WithCollision.GetRandom(caster.Position.X.Get(), caster.Position.Y.Get(), AREA_RANGE, TARGET_FILTER)

        if (target != NULL) then
            call caster.Order.UnitTargetBySpell(Heal.THIS_SPELL, target)
        endif
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AICastSpell.CreateBasics(Heal.THIS_SPELL, function thistype.Event)

        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call whichCombination.Periodic.Add(1.)
    endmethod
endstruct