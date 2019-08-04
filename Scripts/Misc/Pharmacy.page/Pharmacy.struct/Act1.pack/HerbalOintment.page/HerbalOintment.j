//! runtextmacro BaseStruct("HerbalOintment", "HERBAL_OINTMENT")
    static Event DAMAGE_EVENT
    static real LIFE_ADD_PER_INTERVAL
    static real MANA_ADD_PER_INTERVAL
    static integer WAVES_AMOUNT

    Timer intervalTimer
    Unit target

    eventMethod Event_Damage
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    timerMethod Heal
        local Timer intervalTimer = Timer.GetExpired()

        local thistype this = intervalTimer.GetData()

        local Unit target = this.target

        call target.HealBySpell(target, thistype.LIFE_ADD_PER_INTERVAL)
        call target.HealManaBySpell(target, thistype.MANA_ADD_PER_INTERVAL)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
        call target.Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local Timer intervalTimer = Timer.Create()

        set this.intervalTimer = intervalTimer
        set this.target = target
        call intervalTimer.SetData(this)
        call target.Event.Add(DAMAGE_EVENT)

        call target.Buffs.Dispel(true, false, true)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Heal)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, params.Spell.GetLevel(), thistype.DURATION)
    endmethod

    initMethod Init of Items_Act1
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Damage)
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.DURATION / thistype.INTERVAL)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        set thistype.LIFE_ADD_PER_INTERVAL = thistype.LIFE_ADD / thistype.WAVES_AMOUNT
        set thistype.MANA_ADD_PER_INTERVAL = thistype.MANA_ADD / thistype.WAVES_AMOUNT
    endmethod
endstruct