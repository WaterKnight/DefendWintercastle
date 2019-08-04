//! runtextmacro Folder("SoakingPoison")
    //! runtextmacro Struct("Target")
        static Unit CASTER
        static real DAMAGE

        Unit caster
        real damage
        Timer intervalTimer

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call this.caster.DamageUnitBySpell(target, Math.Min(this.damage, target.Life.Get() - UNIT.Life.IMMORTAL), false, false)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = thistype.CASTER
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer intervalTimer = Timer.Create()

            set this.caster = caster
            set this.damage = thistype.DAMAGE
            set this.intervalTimer = intervalTimer
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real duration

            if target.Classes.Contains(UnitClass.HERO) then
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
            call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SoakingPoison", "SOAKING_POISON")
    static Event DAMAGE_EVENT

    //! runtextmacro LinkToStruct("SoakingPoison", "Target")

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
        local Unit target = params.Unit.GetTrigger()

        if not thistype.Conditions(target) then
            return
        endif

        call thistype(NULL).Target.Start(params.Unit.GetDamager(), params.Unit.GetDamager().Abilities.GetLevel(thistype.THIS_SPELL), target)
    endmethod

    eventMethod Event_BuffLose
        call params.Unit.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        call params.Unit.GetTrigger().Event.Add(DAMAGE_EVENT)
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