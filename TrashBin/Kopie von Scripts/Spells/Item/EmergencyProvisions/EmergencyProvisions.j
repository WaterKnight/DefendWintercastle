//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("EmergencyProvisions", "EMERGENCY_PROVISIONS")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static real HEAL

    static Spell THIS_SPELL

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(caster, thistype.HEAL)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_EmergencyProvisions.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct