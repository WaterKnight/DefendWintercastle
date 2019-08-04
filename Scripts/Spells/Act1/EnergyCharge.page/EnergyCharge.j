//! runtextmacro Folder("EnergyCharge")
    //! runtextmacro Struct("Target")
        static Event DAMAGE_EVENT

        eventMethod Event_Damage
            local Unit target = params.Unit.GetDamager()

            call target.HealBySpell(target, thistype.HEAL)

            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local integer level = params.Buff.GetLevel()

            call target.Event.Remove(DAMAGE_EVENT)

            set level = target.Abilities.GetLevel(EnergyCharge.THIS_SPELL)

            if (level > 0) then
                call target.Buffs.Add(EnergyCharge.DUMMY_BUFF, level)
            endif
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()

            call target.Buffs.Remove(EnergyCharge.DUMMY_BUFF)

            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EnergyCharge", "ENERGY_CHARGE")
    static Event DAMAGE_EVENT

    integer attackCount
    UnitEffect targetEffect
    UnitEffect targetEffect2

    //! runtextmacro LinkToStruct("EnergyCharge", "Target")

    static method Conditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_Damage
		local Unit caster = params.Unit.GetDamager()        
        local Unit target = params.Unit.GetTrigger()

        if not thistype.Conditions(target) then
            return
        endif

        local thistype this = caster

        local integer attackCount = this.attackCount + 1

        if (attackCount == thistype.ATTACKS_AMOUNT_NEEDED) then
            set this.attackCount = 0
            call this.targetEffect.Destroy()
            call this.targetEffect2.Destroy()

            call thistype(NULL).Target.Start(params.Spell.GetLevel(), caster)
        else
            set this.attackCount = attackCount
            if (attackCount == 1) then
                set this.targetEffect = caster.Effects.Create(thistype.CHARGE_EFFECT_PATH, thistype.CHARGE_EFFECT_ATTACH_POINT, EffectLevel.LOW)
            elseif (attackCount == 2) then
                set this.targetEffect2 = caster.Effects.Create(thistype.CHARGE_EFFECT2_PATH, thistype.CHARGE_EFFECT2_ATTACH_POINT, EffectLevel.LOW)
            endif
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DAMAGE_EVENT)
        if (this.attackCount == 2) then
            call this.targetEffect.Destroy()
            call this.targetEffect2.Destroy()
        elseif (this.attackCount == 1) then
            call this.targetEffect.Destroy()
        endif
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.attackCount = 0

        call target.Event.Add(DAMAGE_EVENT)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Act1
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        call thistype(NULL).Target.Init()
    endmethod
endstruct