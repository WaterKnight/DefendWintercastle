//! runtextmacro BaseStruct("AIChaosBall", "A_I_CHAOS_BALL")
    static constant real AREA_RANGE = 500.
    static BoolExpr TARGET_FILTER

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
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

        local Unit target = GROUP.EnumUnits.InRange.WithCollision.GetRandom(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.AREA_RANGE, thistype.TARGET_FILTER)

        if (target == NULL) then
            return
        endif

		call caster.Order.UnitTargetBySpell(ChaosBall.THIS_SPELL, target)
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AICastSpell.CreateBasics(ChaosBall.THIS_SPELL, function thistype.Event)

        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call whichCombination.Events.Create(UNIT.Attack.Events.Acquire2.DUMMY_EVENT_TYPE, EventPriority.AI, NULL)
    endmethod
endstruct