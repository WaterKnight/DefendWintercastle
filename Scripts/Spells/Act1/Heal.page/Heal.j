//! runtextmacro BaseStruct("Heal", "HEAL")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

        call caster.HealBySpell(target, thistype.HEAL)
    endmethod

    initMethod Init of Spells_Act1
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct