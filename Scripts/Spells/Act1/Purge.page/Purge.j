//! runtextmacro BaseStruct("Purge", "PURGE")
    static UnitState THIS_STATE

    UnitModSet speedMod
    integer powerLevel
    Timer weakenTimer

    timerMethod Weaken
        local thistype this = Timer.GetExpired().GetData()

        local UnitModSet speedMod = this.speedMod
        local integer powerLevel = this.powerLevel - 1
        local Unit target = this

        set this.powerLevel = powerLevel

        call target.ModSets.Remove(speedMod)

        call speedMod.RealMods.ResetVal(thistype.THIS_STATE, thistype.SPEED_INC * (powerLevel / thistype.POWER_LEVELS))

        call target.ModSets.Add(speedMod)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitModSet speedMod = this.speedMod
        local Timer weakenTimer = this.weakenTimer

        call weakenTimer.Destroy()

        call target.ModSets.Remove(speedMod)

        call speedMod.Destroy()
    endmethod

    static real DUR

    eventMethod Event_BuffGain
        local real duration = thistype.DUR
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitModSet speedMod = UnitModSet.Create()
        local Timer weakenTimer = Timer.Create()

        set this.powerLevel = thistype.POWER_LEVELS
        set this.speedMod = speedMod
        set this.weakenTimer = weakenTimer
        call weakenTimer.SetData(this)

        call speedMod.RealMods.Add(thistype.THIS_STATE, thistype.SPEED_INC)

        call target.ModSets.Add(speedMod)

        call weakenTimer.Start(duration / thistype.POWER_LEVELS, true, function thistype.Weaken)
    endmethod

    static method Start takes integer level, Unit target, real duration returns nothing
        if target.MagicImmunity.Try() then
            return
        endif

        call target.Buffs.Dispel(false, true, true)

        set thistype.DUR = duration

        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
    endmethod

    eventMethod Event_SpellEffect
    	local integer level = params.Spell.GetLevel()
    	local Unit target = params.Unit.GetTarget()

		local real duration

		if target.Classes.Contains(UnitClass.HERO) then
			set duration = thistype.HERO_DURATION
		else
			set duration = thistype.DURATION
		endif

        call thistype.Start(level, target, duration)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.THIS_STATE = UNIT.Movement.Speed.RelativeA.STATE

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct