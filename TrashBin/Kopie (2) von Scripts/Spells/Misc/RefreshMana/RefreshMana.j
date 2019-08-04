//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("RefreshMana", "REFRESH_MANA")
    static Unit CASTER
    static real MANA_FACTOR
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH

    static Spell THIS_SPELL

    static method Enum takes nothing returns nothing
        local Unit caster = thistype.CASTER
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.HealManaBySpell(target, target.MaxMana.GetAll() * thistype.MANA_FACTOR)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        set thistype.CASTER = UNIT.Event.GetTrigger()

        call USER.Hero.EnumAll(function thistype.Enum, true)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_RefreshMana.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct