//! runtextmacro BaseStruct("CoreFusion", "CORE_FUSION")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call caster.HealBySpell(caster, thistype.HEAL_FACTOR * caster.MaxLife.Get())
        call SpotEffectWithSize.Create(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW, 5.).Destroy()

        call Meteorite.Update()
    endmethod

    initMethod Init of Spells_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct