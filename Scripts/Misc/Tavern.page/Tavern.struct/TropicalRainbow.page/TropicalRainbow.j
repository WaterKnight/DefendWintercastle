//! runtextmacro BaseStruct("TropicalRainbow", "TROPICAL_RAINBOW")
    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, params.Spell.GetLevel(), thistype.DURATION)
    endmethod

    initMethod Init of Items_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct