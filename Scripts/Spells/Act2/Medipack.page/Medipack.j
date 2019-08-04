//! runtextmacro BaseStruct("Medipack", "MEDIPACK")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.Buffs.Dispel(true, false, true)
        call caster.HealBySpell(caster, thistype.HEAL)
    endmethod

    initMethod Init of Spells_Act2
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct