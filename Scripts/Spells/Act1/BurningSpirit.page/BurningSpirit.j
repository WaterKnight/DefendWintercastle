//! runtextmacro BaseStruct("BurningSpirit", "BURNING_SPIRIT")
    eventMethod Event_SpellEffect
        call params.Unit.GetTarget().Buffs.Timed.Start(thistype.DUMMY_BUFF, params.Spell.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct