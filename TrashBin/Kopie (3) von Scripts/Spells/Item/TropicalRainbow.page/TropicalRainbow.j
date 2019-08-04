//! runtextmacro BaseStruct("TropicalRainbow", "TROPICAL_RAINBOW")
    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Damage.Relative.Subtract(thistype.DAMAGE_RELATIVE_INCREMENT)
        call target.LifeRegeneration.Relative.Subtract(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
        call target.ManaRegeneration.Relative.Subtract(thistype.MANA_REGENERATION_RELATIVE_INCREMENT)
        call target.Movement.Speed.RelativeA.Subtract(thistype.SPEED_RELATIVE_INCREMENT)
        call target.SpellPower.Relative.Subtract(thistype.SPELL_POWER_RELATIVE_INCREMENT)
        call target.VertexColor.Subtract(0., -128., -64., 0.)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Damage.Relative.Add(thistype.DAMAGE_RELATIVE_INCREMENT)
        call target.LifeRegeneration.Relative.Add(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
        call target.ManaRegeneration.Relative.Add(thistype.MANA_REGENERATION_RELATIVE_INCREMENT)
        call target.Movement.Speed.RelativeA.Add(thistype.SPEED_RELATIVE_INCREMENT)
        call target.SpellPower.Relative.Add(thistype.SPELL_POWER_RELATIVE_INCREMENT)
        call target.VertexColor.Add(0., -128., -64., 0.)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct