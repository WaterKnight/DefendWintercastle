//! runtextmacro BaseStruct("SilentBoots", "SILENT_BOOTS")
	static Event DAMAGE_EVENT
    static Event INVISIBILITY_EVENT

    integer level
    UnitModSet moveSpeedMod
    integer powerLevel
    Timer snowTimer
    Timer weakenTimer

    eventMethod Event_Damage
    	local Unit caster = params.Unit.GetTrigger()
    	local real damage = params.Real.GetDamage()
        local Unit target = params.Unit.GetTarget()

		local integer level = caster.Buffs.GetLevel(thistype.DUMMY_BUFF)

		local real disarmDuration

		if target.Classes.Contains(UnitClass.HERO) then
			set disarmDuration = thistype.DISARM_HERO_DURATION[level]
		else
			set disarmDuration = thistype.DISARM_DURATION[level]
		endif

		call target.Attack.DisableTimed(disarmDuration)
		call target.Silence.AddTimed(disarmDuration)

		call params.Real.SetDamage(damage + thistype.EXTRA_DAMAGE[level])
    endmethod

    eventMethod Event_InvisibilityEnding
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    timerMethod SpawnSnow
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        local real x = target.Position.X.Get()
        local real y = target.Position.Y.Get()

        //call TileTypeMod.Create(x, y, TileType.SNOW).DestroyTimed.Start(3.)
        call Ubersplat.Create(UbersplatType.SNOW, x, y, 255, 255, 255, target.Buffs.Timed.GetRemainingDuration(thistype.DUMMY_BUFF, this.level) / thistype.DURATION[this.level] * SetVar.GetValDefR("snowAlphaFactor", 1.5) * 255, false, false).DestroyTimed.Start(SetVar.GetValDefR("snowDur", 5.))
    endmethod

    timerMethod Weaken
        local thistype this = Timer.GetExpired().GetData()

        local UnitModSet moveSpeedMod = this.moveSpeedMod
        local integer level = this.level
        local integer powerLevel = this.powerLevel - 1
        local Unit target = this

        set this.powerLevel = powerLevel

        call target.ModSets.Remove(moveSpeedMod)

        call moveSpeedMod.RealMods.ResetVal(UNIT.Movement.Speed.BonusA.STATE, thistype.MOVE_SPEED_BONUS[level] * (powerLevel / thistype.POWER_LEVELS))

        call target.ModSets.Add(moveSpeedMod)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitModSet moveSpeedMod = this.moveSpeedMod
        local Timer snowTimer = this.snowTimer
        local Timer weakenTimer = this.weakenTimer

        call snowTimer.Destroy()
        call weakenTimer.Destroy()
        call target.Event.Remove(DAMAGE_EVENT)
        call target.Event.Remove(INVISIBILITY_EVENT)

        call target.ModSets.Remove(moveSpeedMod)

        call moveSpeedMod.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitModSet moveSpeedMod = UnitModSet.Create()
        local Timer snowTimer = Timer.Create()
        local Timer weakenTimer = Timer.Create()

        set this.level = level
        set this.moveSpeedMod = moveSpeedMod
        set this.powerLevel = thistype.POWER_LEVELS
        set this.snowTimer = snowTimer
        set this.weakenTimer = weakenTimer
        call snowTimer.SetData(this)
        call weakenTimer.SetData(this)

		call target.Event.Add(DAMAGE_EVENT)
        call target.Event.Add(INVISIBILITY_EVENT)

        call moveSpeedMod.RealMods.Add(UNIT.Movement.Speed.BonusA.STATE, thistype.MOVE_SPEED_BONUS[level])

        call target.ModSets.Add(moveSpeedMod)

        call snowTimer.Start(SetVar.GetValDefR("snow", 0.125), true, function thistype.SpawnSnow)
        call weakenTimer.Start(thistype.DURATION[level] / thistype.POWER_LEVELS, true, function thistype.Weaken)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

		//call caster.Buffs.Dispel(true, false, true)

        call caster.Invisibility.AddTimed(thistype.DURATION[level])
        call caster.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Artifacts
    	set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.INVISIBILITY_EVENT = Event.Create(UNIT.Invisibility.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_InvisibilityEnding)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Invisibility.TIMED_BUFF.Variants.Add(thistype.DUMMY_BUFF)
    endmethod
endstruct