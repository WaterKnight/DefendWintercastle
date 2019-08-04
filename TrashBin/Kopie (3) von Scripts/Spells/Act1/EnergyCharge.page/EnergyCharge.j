//! runtextmacro Folder("EnergyCharge")
    //! runtextmacro Struct("Target")
        static Event DAMAGE_EVENT

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local integer level = BUFF.Event.GetLevel()

            call target.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
            call target.Event.Remove(DAMAGE_EVENT)

            call target.Buffs.Add(EnergyCharge.DUMMY_BUFF, level)
        endmethod

        static method Event_Damage takes nothing returns nothing
            local Unit target = UNIT.Event.GetDamager()

            call target.HealBySpell(target, thistype.HEAL)

            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Buffs.Remove(EnergyCharge.DUMMY_BUFF)

            call target.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
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
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif

        return true
    endmethod

    static method Event_Damage takes nothing returns nothing
        local integer attackCount
        local Unit caster
        local Unit target = UNIT.Event.GetTrigger()
        local thistype this

        if (thistype.Conditions(target) == false) then
            return
        endif

        set caster = UNIT.Event.GetDamager()

        set this = caster

        set attackCount = this.attackCount + 1

        if (attackCount == thistype.ATTACKS_AMOUNT_NEEDED) then
            set this.attackCount = 0
            call this.targetEffect.Destroy()
            call this.targetEffect2.Destroy()

            call thistype(NULL).Target.Start(SPELL.Event.GetLevel(), caster)
        else
            set this.attackCount = attackCount
            if (attackCount == 1) then
                set this.targetEffect = caster.Effects.Create("Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
            elseif (attackCount == 2) then
                set this.targetEffect2 = caster.Effects.Create("Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
            endif
        endif
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DAMAGE_EVENT)
        if (this.attackCount == 2) then
            call this.targetEffect.Destroy()
            call this.targetEffect2.Destroy()
        elseif (this.attackCount == 1) then
            call this.targetEffect.Destroy()
        endif
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.attackCount = 0

        call target.Event.Add(DAMAGE_EVENT)
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

        call thistype(NULL).Target.Init()
    endmethod
endstruct