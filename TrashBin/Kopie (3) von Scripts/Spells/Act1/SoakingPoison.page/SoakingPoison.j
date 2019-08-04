//! runtextmacro Folder("SoakingPoison")
    //! runtextmacro Struct("Target")
        static Unit CASTER
        static real DAMAGE

        Unit caster
        real damage
        Timer intervalTimer

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
            call target.Poisoned.Subtract()
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call this.caster.DamageUnitBySpell(target, Math.Min(this.damage, target.Life.Get() - UNIT.Life.IMMORTAL), false, false)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = thistype.CASTER
            local Timer intervalTimer = Timer.Create()
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.caster = caster
            set this.damage = thistype.DAMAGE
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)
            call target.Poisoned.Add()

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real duration

            if (target.Classes.Contains(UnitClass.HERO)) then
                set duration = thistype.HERO_DURATION
            else
                set duration = thistype.DURATION
            endif

            set thistype.CASTER = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SoakingPoison", "SOAKING_POISON")
    static Event DAMAGE_EVENT

    //! runtextmacro LinkToStruct("SoakingPoison", "Target")

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
        local Unit target = UNIT.Event.GetTrigger()

        if (thistype.Conditions(target) == false) then
            return
        endif

        call thistype(NULL).Target.Start(UNIT.Event.GetDamager(), UNIT.Event.GetDamager().Abilities.GetLevel(thistype.THIS_SPELL), target)
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

        call thistype(NULL).Target.Init()
    endmethod
endstruct