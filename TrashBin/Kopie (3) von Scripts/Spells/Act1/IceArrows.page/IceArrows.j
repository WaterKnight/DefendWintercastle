//! runtextmacro BaseStruct("IceArrows", "ICE_ARROWS")
    static Event DAMAGE_EVENT

    static method AddCold takes integer level, Unit target returns nothing
        local real duration

        if (target.Classes.Contains(UnitClass.HERO)) then
            set duration = thistype.HERO_DURATION
        else
            set duration = thistype.DURATION
        endif

        call target.Cold.AddTimed(duration)
    endmethod

    static method Conditions takes Unit target returns boolean
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit caster = UNIT.Event.GetDamager()
        local Unit target = UNIT.Event.GetTrigger()

        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

        local real mana = caster.Mana.Get() - thistype.THIS_SPELL.GetManaCost(level)

        if (mana < 0.) then
            return
        endif

        call caster.Mana.Set(mana)

        if (thistype.Conditions(target) == false) then
            return
        endif

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call thistype(NULL).AddCold(level, target)

        call caster.DamageUnitBySpell(target, thistype.DAMAGE, true, false)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct