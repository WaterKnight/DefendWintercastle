//! runtextmacro BaseStruct("Lariat", "LARIAT")
    static real array DAMAGE_PER_INTERVAL
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    real damage
    Lightning effectLightning
    Timer intervalTimer
    Unit target

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        call caster.DamageUnitBySpell(target, this.damage, true, false)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            local Unit caster = this

            call caster.Stop()

            set iteration = iteration - 1
        endloop
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster

        local Lightning effectLightning = this.effectLightning
        local Timer intervalTimer = this.intervalTimer
        local Unit target = this.target

        call effectLightning.Destroy()
        call intervalTimer.Destroy()
        if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        endif

        if success then
            call caster.Order.UnitTarget(Order.ATTACK, target)
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local thistype this = caster

		local Lightning effectLightning = Lightning.Create(thistype.BOLT)
		local Timer intervalTimer = Timer.Create()

        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.effectLightning = effectLightning
        set this.intervalTimer = intervalTimer
        set this.target = target
        call intervalTimer.SetData(this)
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Buffs.Add(thistype.DUMMY_BUFF, 1)
        endif

        call effectLightning.FromUnitToUnit.Start(caster, target)

        call intervalTimer.Start(thistype.INTERVAL[level], true, function thistype.Interval)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_PER_SECOND[iteration] * thistype.INTERVAL[iteration]

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct