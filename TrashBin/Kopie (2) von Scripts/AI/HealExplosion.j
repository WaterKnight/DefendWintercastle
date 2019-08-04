//! runtextmacro BaseStruct("AIHealExplosion", "A_I_HEAL_EXPLOSION")
    static method Event takes nothing returns nothing
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())

        if (caster.Classes.Contains(UnitClass.DEAD)) then
            return
        endif

        set User.TEMP = caster.Owner.Get()

        call HealExplosion.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), HealExplosion.THIS_SPELL.GetAreaRange(caster.Abilities.GetLevel(HealExplosion.THIS_SPELL)), HealExplosion.HEAL_TARGET_FILTER)

        if (HealExplosion.ENUM_GROUP.Count() > 3) then
            call caster.Order.ImmediateBySpell(HealExplosion.THIS_SPELL)
        endif
    endmethod

    static method Init takes nothing returns nothing
        local EventCombination whichCombination = AICastSpell.CreateBasics(HealExplosion.THIS_SPELL, function thistype.Event)

        call whichCombination.Periodic.Add(1.)
    endmethod
endstruct