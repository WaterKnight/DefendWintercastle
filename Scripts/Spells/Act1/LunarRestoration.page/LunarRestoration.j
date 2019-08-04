//! runtextmacro Folder("LunarRestoration")
    //! runtextmacro Struct("Revival")
        static Event REVIVE_EVENT

        Timer durationTimer
        integer level
        SpotEffect specialEffect
        real targetX
        real targetY

        timerMethod EndingByTimer
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local integer level = this.level
            local Unit target = this

            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call target.Revive()

            call target.Life.Set(target.MaxLife.Get() * thistype.LIFE_FACTOR)
            call target.Mana.Set(target.MaxMana.Get() * thistype.MANA_FACTOR - LunarRestoration.THIS_SPELL.GetManaCost(level))
        endmethod

        eventMethod Event_Revive
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local SpotEffect specialEffect = this.specialEffect

            call durationTimer.Destroy()
            call specialEffect.Destroy()
            call target.Event.Remove(REVIVE_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local Timer durationTimer = Timer.Create()
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local thistype this = target

            set this.durationTimer = durationTimer
            set this.level = level
            set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
            set this.targetX = targetX
            set this.targetY = targetY
            call durationTimer.SetData(this)
            call target.Event.Add(REVIVE_EVENT)

            call target.Revival.Set(true)

            call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Revive)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("LunarRestoration", "LUNAR_RESTORATION")
    static Event DEATH_EVENT
    static Event array MANA_GAIN_EVENT
    static Event array MANA_LOSE_EVENT

    boolean active
    integer level
    Event manaGainEvent
    Event manaLoseEvent

    //! runtextmacro LinkToStruct("LunarRestoration", "Revival")

    eventMethod Event_Death
        local Unit target = params.Unit.GetTrigger()

        if target.Revival.Is() then
            return
        endif

        local integer level = target.Abilities.GetLevel(thistype.THIS_SPELL)

        call thistype(NULL).Revival.Start(level, target)
    endmethod

    eventMethod Event_EffectBuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DEATH_EVENT)
    endmethod

    eventMethod Event_EffectBuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Event.Add(DEATH_EVENT)
    endmethod

    eventMethod Event_ManaLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.active = false
        call target.Event.Add(this.manaGainEvent)
        call target.Event.Remove(this.manaLoseEvent)

        call target.Buffs.Remove(thistype.EFFECT_BUFF)
    endmethod

    eventMethod Event_ManaGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.active = true
        call target.Event.Add(this.manaLoseEvent)
        call target.Event.Remove(this.manaGainEvent)

        call target.Buffs.Add(thistype.EFFECT_BUFF, this.level)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        if this.active then
            call target.Event.Remove(this.manaLoseEvent)

            call target.Buffs.Remove(thistype.EFFECT_BUFF)
        else
            call target.Event.Remove(this.manaGainEvent)
        endif
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Event manaGainEvent = thistype.MANA_GAIN_EVENT[level]
        local Event manaLoseEvent = thistype.MANA_LOSE_EVENT[level]

        set this.level = level
        set this.manaGainEvent = manaGainEvent
        set this.manaLoseEvent = manaLoseEvent

        if (target.Mana.Get() < thistype.THIS_SPELL.GetManaCost(level)) then
            set this.active = false
            call target.Event.Add(manaGainEvent)
        else
            set this.active = true
            call target.Event.Add(manaLoseEvent)

            call target.Buffs.Add(thistype.EFFECT_BUFF, level)
        endif
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Act1
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.EFFECT_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EffectBuffGain))
        call thistype.EFFECT_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EffectBuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.MANA_GAIN_EVENT[iteration] = Event.CreateLimit(UNIT.Mana.DUMMY_EVENT_TYPE, EventPriority.SPELLS, Real.ToInt(thistype.THIS_SPELL.GetManaCost(iteration)), GREATER_THAN_OR_EQUAL, function thistype.Event_ManaGain)
            set thistype.MANA_LOSE_EVENT[iteration] = Event.CreateLimit(UNIT.Mana.DUMMY_EVENT_TYPE, EventPriority.SPELLS, Real.ToInt(thistype.THIS_SPELL.GetManaCost(iteration)), LESS_THAN, function thistype.Event_ManaLose)

            set iteration = iteration - 1
        endloop

        call thistype(NULL).Revival.Init()
    endmethod
endstruct