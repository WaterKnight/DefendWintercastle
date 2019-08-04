//! runtextmacro BaseStruct("IceBlock", "ICE_BLOCK")
    real lifeRegenerationAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real lifeRegenerationAdd = this.lifeRegenerationAdd

        call target.Invulnerability.Subtract(UNIT.Invulnerability.NONE_BUFF)
        call target.LifeRegeneration.Bonus.Subtract(lifeRegenerationAdd)
        call target.MagicImmunity.Subtract(UNIT.MagicImmunity.NONE_BUFF)
        call target.Stun.Subtract(UNIT.Stun.NONE_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real lifeRegenerationAdd = thistype.LIFE_REGENERATION_INCREMENT[level]
        local thistype this = target

        set this.lifeRegenerationAdd = lifeRegenerationAdd
        call target.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
        call target.LifeRegeneration.Bonus.Add(lifeRegenerationAdd)
        call target.MagicImmunity.Add(UNIT.MagicImmunity.NONE_BUFF)
        call target.Stun.Add(UNIT.Stun.NONE_BUFF)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local integer level = SPELL.Event.GetLevel()

        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct