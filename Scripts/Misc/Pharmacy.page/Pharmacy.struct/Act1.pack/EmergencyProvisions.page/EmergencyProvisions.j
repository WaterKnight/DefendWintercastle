//! runtextmacro BaseStruct("EmergencyProvisions", "EMERGENCY_PROVISIONS")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(caster, thistype.HEAL)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))
    endmethod
endstruct