//! runtextmacro BaseStruct("RefreshMana", "REFRESH_MANA")
    static Unit CASTER

    enumMethod Enum
        local Unit caster = thistype.CASTER
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.HealManaBySpell(target, target.MaxMana.Get() * thistype.MANA_FACTOR)
    endmethod

    eventMethod Event_SpellEffect
        set thistype.CASTER = params.Unit.GetTrigger()

        call USER.Hero.EnumAll(function thistype.Enum, true)
    endmethod

    initMethod Init of Spells_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct