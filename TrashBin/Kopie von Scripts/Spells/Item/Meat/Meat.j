//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("Meat", "MEAT")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static Event DEATH_EVENT
    static real DURATION
    static real HEAL
    static real HEAL_PER_INTERVAL
    static real INTERVAL
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static integer WAVES_AMOUNT

    static Spell THIS_SPELL

    Unit caster
    Timer durationTimer
    Timer intervalTimer

    method Ending takes Unit caster, Timer durationTimer returns nothing
        local Timer intervalTimer = this.intervalTimer

        call this.deallocate()
        if (caster.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call caster.Event.Remove(DEATH_EVENT)
        endif
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        call this.Ending(this.caster, durationTimer)
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Ending(caster, this.durationTimer)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Heal takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(caster, thistype.HEAL_PER_INTERVAL)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.durationTimer = durationTimer
        set this.intervalTimer = intervalTimer
        if (caster.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call caster.Event.Add(DEATH_EVENT)
        endif
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Heal)

        call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Meat.j

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Death)
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.DURATION / thistype.INTERVAL)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

        set thistype.HEAL_PER_INTERVAL = thistype.HEAL / thistype.WAVES_AMOUNT

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct