//! runtextmacro BaseStruct("AIStomp", "A_I_STOMP")
    eventMethod Event
        local Unit caster = Unit.GetFromId(params.GetSubjectId())

        if caster.Classes.Contains(UnitClass.DEAD) then
            return
        endif

        set User.TEMP = caster.Owner.Get()

        call Stomp.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), Stomp.THIS_SPELL.GetAreaRange(caster.Abilities.GetLevel(Stomp.THIS_SPELL)), Stomp.TARGET_FILTER)

        if (Stomp.ENUM_GROUP.Count() < 2) then
            return
        endif

		call caster.Order.ImmediateBySpell(Stomp.THIS_SPELL)
    endmethod

    initMethod Init of AI_Spells
        local EventCombination whichCombination = AICastSpell.CreateBasics(Stomp.THIS_SPELL, function thistype.Event)

        call whichCombination.Periodic.Add(5.)
    endmethod
endstruct