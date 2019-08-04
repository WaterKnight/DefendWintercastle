//! runtextmacro BaseStruct("FuzzyAttack", "FUZZY_ATTACK")
    static real INTERVAL
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    Unit caster
    Timer delayTimer
    integer remainingMissiles
    Unit target
    SpellInstance whichInstance

    method Ending takes Unit caster returns nothing
        local Timer delayTimer = this.delayTimer
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call caster.Data.Integer.Table.Remove(KEY_ARRAY, this)
        call delayTimer.Destroy()
        call whichInstance.Destroy()
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()

        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            if (this.remainingMissiles == 0) then
                call this.Ending(caster)
            else
                call this.delayTimer.Pause()
            endif

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer remainingMissiles = this.remainingMissiles - 1
        local Unit target = this.target

        call dummyMissile.Destroy()

        call caster.DamageUnitBySpell(this.target, thistype.DAMAGE_PER_MISSILE, true, false)

        if (remainingMissiles == 0) then
            call this.Ending(caster)
        else
            set this.remainingMissiles = remainingMissiles
        endif
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

		local Missile dummyMissile = Missile.Create()

        set this.remainingMissiles = this.remainingMissiles + 1

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(32.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetFromUnit(this.caster)

        call dummyMissile.GoToUnit.Start(this.target, null)
    endmethod

    timerMethod Delay
        call Timer.GetExpired().Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()

		local thistype this = thistype.allocate()

        local Timer delayTimer = Timer.Create()

        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.remainingMissiles = 0
        set this.target = target
        set this.whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)
        call caster.Data.Integer.Table.Add(KEY_ARRAY, this)
        call delayTimer.SetData(this)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Delay)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.INTERVAL = (thistype.THIS_SPELL.GetChannelTime(1) - thistype.DELAY) / thistype.INTERVALS_AMOUNT - 0.01
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct