//! runtextmacro BaseStruct("IceTea", "ICE_TEA")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call caster.HealManaBySpell(caster, thistype.REFRESHED_MANA[level])
    endmethod

    initMethod Init of Items_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))
    endmethod
endstruct