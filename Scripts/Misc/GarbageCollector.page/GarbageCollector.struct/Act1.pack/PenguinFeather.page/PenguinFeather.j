//! runtextmacro BaseStruct("PenguinFeather", "PENGUIN_FEATHER")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()

        call target.Effects.Create(thistype.HEAL_EFFECT_PATH, thistype.HEAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(target, thistype.HEAL)
    endmethod

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.EvasionChance.Bonus.Subtract(thistype.EVASION_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.EvasionChance.Bonus.Add(thistype.EVASION_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct