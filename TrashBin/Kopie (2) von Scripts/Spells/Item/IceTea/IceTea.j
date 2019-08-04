//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("IceTea", "ICE_TEA")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static real array REFRESHED_MANA

    static Spell THIS_SPELL

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call caster.HealManaBySpell(caster, thistype.REFRESHED_MANA[level])
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_IceTea.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct