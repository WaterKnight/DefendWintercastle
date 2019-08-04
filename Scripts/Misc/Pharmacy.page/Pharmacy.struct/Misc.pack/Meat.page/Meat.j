//! runtextmacro BaseStruct("Meat", "MEAT")
    static Event DEATH_EVENT
    static real HEAL_PER_INTERVAL
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static integer WAVES_AMOUNT

    Unit caster
    Timer durationTimer
    Timer intervalTimer

    method Ending takes Unit caster, Timer durationTimer returns nothing
        local Timer intervalTimer = this.intervalTimer

        call this.deallocate()
        if caster.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call caster.Event.Remove(DEATH_EVENT)
        endif
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    timerMethod EndingByTimer
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        call this.Ending(this.caster, durationTimer)
    endmethod

    eventMethod Event_Death
        local Unit caster = params.Unit.GetTrigger()

        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Ending(caster, this.durationTimer)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    timerMethod Heal
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(caster, thistype.HEAL_PER_INTERVAL)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.durationTimer = durationTimer
        set this.intervalTimer = intervalTimer
        if caster.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call caster.Event.Add(DEATH_EVENT)
        endif
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Heal)

        call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
    endmethod

    initMethod Init of Items_Misc
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Death)
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.DURATION / thistype.INTERVAL)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        set thistype.HEAL_PER_INTERVAL = thistype.HEAL / thistype.WAVES_AMOUNT
    endmethod
endstruct