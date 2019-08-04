//! runtextmacro BaseStruct("VioletEarring", "VIOLET_EARRING")
    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local integer iteration = caster.Abilities.Count()
        local Spell whichSpell

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.Abilities.Refresh(Crippling.THIS_SPELL)
        call caster.Abilities.Refresh(ManaLaser.THIS_SPELL)
        call caster.Mana.Add(thistype.MANA_INCREMENT[level])
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct