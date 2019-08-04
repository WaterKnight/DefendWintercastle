//! runtextmacro BaseStruct("Boost", "BOOST")
    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()

        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
    endmethod

    initMethod Init of Spells_Act1
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct