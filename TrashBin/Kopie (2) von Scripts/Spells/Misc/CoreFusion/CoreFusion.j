//! runtextmacro BaseStruct("CoreFusion", "CORE_FUSION")
    static real HEAL_FACTOR
    static string SPECIAL_EFFECT_PATH

    static Spell THIS_SPELL

    //! import "obj_CoreFusion.j"

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        call caster.HealBySpell(caster, thistype.HEAL_FACTOR * caster.MaxLife.GetAll())
        call SpotEffectWithSize.Create(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW, 5.).Destroy()

        call Meteorite.Update()
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct