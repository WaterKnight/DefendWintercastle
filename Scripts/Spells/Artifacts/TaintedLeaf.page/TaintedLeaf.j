//! runtextmacro BaseStruct("TaintedLeaf", "TAINTED_LEAF")
    static real array HEAL_PER_INTERVAL
    static BoolExpr TARGET_FILTER

    Unit caster
    Timer intervalTimer
    integer level

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()
        
        local Unit target = this
        
        local Unit caster = this.caster
        local integer level = this.level

        call caster.HealBySpell(target, thistype.HEAL_PER_INTERVAL[level])
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer
        local integer level = this.level

        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()
return
        local thistype this = target

        local Timer intervalTimer = Timer.Create()

        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.HEAL_INTERVAL, true, function thistype.Interval)
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

	Group cast_targetGroup

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real damage = thistype.DAMAGE[level]
		local Group targetGroup = thistype(caster).cast_targetGroup
        local UnitType targetType = target.Type.Get()
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        call SpotEffectWithSize.Create(targetX, targetY, thistype.HEAL_TARGET_EFFECT_PATH, EffectLevel.NORMAL, areaRange / 160.).Destroy()

        if target.IsAllyOf(caster.Owner.Get()) then
            call target.Buffs.Timed.DoWithLevel(thistype.TAINTED_BUFF, level, caster, thistype.BUFF_DURATION[level])
            call caster.HealBySpell(target, (thistype.HEAL_FACTOR[level] * target.MaxLife.Get()) * (1. - Boolean.ToInt(target == caster) * (1. - thistype.SELF_FACTOR)))
        else
            if target.Classes.Contains(UnitClass.HERO) then
                call target.Buffs.Timed.Start(thistype.SLEEP_BUFF, level, thistype.SLEEP_HERO_DURATION[level])
            else
                call target.Buffs.Timed.Start(thistype.SLEEP_BUFF, level, thistype.SLEEP_DURATION[level])
            endif

	        set target = targetGroup.FetchFirst()
	
	        if (target != NULL) then
	            loop
	                call caster.DamageUnitBySpell(target, damage, true, false)
	
	                set target = targetGroup.FetchFirst()
	                exitwhen (target == NULL)
	            endloop
	        endif
        endif
    endmethod

	eventMethod Event_Cast_BuffLose
		local Unit caster = params.Unit.GetTrigger()

		local thistype this = caster

		local Group targetGroup = this.cast_targetGroup

		call targetGroup.Destroy()
	endmethod

	static integer CAST_LEVEL
	static Unit CAST_TARGET
	static real CAST_TARGET_X
	static real CAST_TARGET_Y

	eventMethod Event_Cast_BuffGain
		local Unit caster = params.Unit.GetTrigger()
		local integer level = thistype.CAST_LEVEL
		local Unit target = thistype.CAST_TARGET
		local real targetX = thistype.CAST_TARGET_X
		local real targetY = thistype.CAST_TARGET_Y

		local Group targetGroup = Group.Create()

		local thistype this = caster

		set this.cast_targetGroup = targetGroup

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = target

        call targetGroup.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)
	endmethod

	eventMethod Event_EndCast
		call params.Unit.GetTrigger().Buffs.Remove(thistype.CAST_BUFF)
	endmethod

	eventMethod Event_Cast
		set thistype.CAST_LEVEL = params.Spell.GetLevel()
		set thistype.CAST_TARGET = params.Unit.GetTarget()
		set thistype.CAST_TARGET_X = params.Spot.GetTargetX()
		set thistype.CAST_TARGET_Y = params.Spot.GetTargetY()

		call params.Unit.GetTrigger().Buffs.Add(thistype.CAST_BUFF, 1)
	endmethod

    initMethod Init of Spells_Artifacts
    	set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.CAST_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Cast_BuffGain))
        call thistype.CAST_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Cast_BuffLose))
        call thistype.TAINTED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.TAINTED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Begin.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Cast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call UNIT.Sleep.NORMAL_BUFF.Variants.Add(thistype.SLEEP_BUFF)

        local integer i = thistype.THIS_SPELL.GetLevelsAmount()

        loop
        	exitwhen (i < 1)

        	set thistype.HEAL_PER_INTERVAL[i] = thistype.HEAL_OVER_TIME[i] / Real.ToInt(thistype.BUFF_DURATION[i] / thistype.HEAL_INTERVAL)

        	set i = i - 1
        endloop
    endmethod
endstruct