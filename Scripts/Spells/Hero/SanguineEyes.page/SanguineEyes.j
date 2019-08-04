//! runtextmacro BaseStruct("SanguineEyes", "SANGUINE_EYES")
    static Event DAMAGE_EVENT

    Unit caster
    real damageToLifeFactor

    eventMethod Event_Damage
        local real damage = params.Real.GetDamage()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call this.caster.HealBySpell(caster, damage * this.damageToLifeFactor)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DAMAGE_EVENT)

        call caster.Abilities.Refresh(thistype.THIS_SPELL)
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.caster = caster
        set this.damageToLifeFactor = thistype.DAMAGE_TO_LIFE_FACTOR[level]

        call target.Event.Add(DAMAGE_EVENT)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, caster, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call UNIT.Bleeding.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        call UNIT.Death.Explosion.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        call UNIT.Stun.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
    endmethod
endstruct