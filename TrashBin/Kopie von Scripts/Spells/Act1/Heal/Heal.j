//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("Heal", "HEAL")
    static real HEAL
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH

    static Spell THIS_SPELL

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Unit target = UNIT.Event.GetTarget()

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

        call caster.HealBySpell(target, thistype.HEAL)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Heal.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct