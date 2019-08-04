//! runtextmacro BaseStruct("Susanoo", "SUSANOO")
    static Event DEATH_EVENT

    real armorAdd
    real durationAdd

    eventMethod Event_Death
        local Unit target = params.Unit.GetKiller()

        local thistype this = target

        local real durationAdd = this.durationAdd

        set this.durationAdd = durationAdd * (1. + thistype.DURATION_ADD_ADD_FACTOR)

        call target.Effects.Create(thistype.ADD_TIME_EFFECT_PATH, thistype.ADD_TIME_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call target.Buffs.Timed.AddTime(thistype.DUMMY_BUFF, durationAdd)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

		call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        local real armorAdd = thistype.ARMOR_INC[level]

        local thistype this = target

        set this.armorAdd = armorAdd
        set this.durationAdd = thistype.DURATION_ADD[level]

        call target.Armor.IgnoreDamage.Relative.Add(armorAdd)
        call target.Event.Add(DEATH_EVENT)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local real armorAdd = this.armorAdd

        call target.Armor.IgnoreDamage.Relative.Subtract(armorAdd)
        call target.Event.Remove(DEATH_EVENT)
    endmethod

    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()

        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.KILLER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct