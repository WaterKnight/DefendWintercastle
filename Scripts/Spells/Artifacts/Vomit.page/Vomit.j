//! runtextmacro Folder("Vomit")
	//! runtextmacro Struct("Target")
		Unit caster
		real damage
		Timer intervalTimer

		timerMethod IntervalByTimer
			local thistype this = Timer.GetExpired().GetData()
			
			local Unit target = this
			
			call this.caster.DamageUnitBySpell(target, this.damage, false, false)
		endmethod
		
		eventMethod BuffLose
			local Unit target = params.Unit.GetTrigger()
			
			local thistype this = target
			
			local Timer intervalTimer = this.intervalTimer
			
			call intervalTimer.Destroy()
		endmethod
	
		eventMethod BuffGain
			local Unit caster = params.Buff.GetData()
			local integer level = params.Buff.GetLevel()
			local Unit target = params.Unit.GetTrigger()

			local real duration

	        if target.Classes.Contains(UnitClass.HERO) then
	            set duration = thistype.POISON_HERO_DURATION[level]
	        else
	            set duration = thistype.POISON_DURATION[level]
	        endif

			local integer wavesAmount = Real.ToInt(duration / thistype.INTERVAL) 

			local thistype this = target

			local Timer intervalTimer = Timer.Create()

			set this.caster = caster
			set this.damage = thistype.DAMAGE_OVER_TIME[level] / wavesAmount
			set this.intervalTimer = intervalTimer
			call intervalTimer.SetData(this)

			call intervalTimer.Start(thistype.INTERVAL, true, function thistype.IntervalByTimer)
		endmethod
		
		method Start takes integer level, Unit target returns nothing
			local real duration
	
	        if target.Classes.Contains(UnitClass.HERO) then
	            set duration = thistype.POISON_HERO_DURATION[level]
	        else
	            set duration = thistype.POISON_DURATION[level]
	        endif
	
	        call target.Buffs.Timed.StartEx(thistype.POISON_BUFF, level, caster, duration)
		endmethod

		static method Init takes nothing returns nothing
    	    call thistype.POISON_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.BuffGain))
	        call thistype.POISON_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.BuffLose))
	        
	        call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.POISON_BUFF)
		endmethod
	endstruct
endscope

//! runtextmacro BaseStruct("Vomit", "VOMIT")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER_COLLISION
    static BoolExpr TARGET_FILTER_EXPLOSION
    
    Unit caster
    integer level
    real scale
    Unit target
    UnitList targetGroup
    SpellInstance whichInstance
    real x
    real y

	//! runtextmacro LinkToStruct("Vomit", "Target")

	static method TargetConditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if ((Unit.TEMP.Classes.Contains(UnitClass.GROUND) != target.Classes.Contains(UnitClass.DEAD)) and (Unit.TEMP.Classes.Contains(UnitClass.AIR) != target.Classes.Contains(UnitClass.AIR))) then
            return false
		endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

		return true
	endmethod

	condMethod TargetConditions_Explosion
		return thistype.TargetConditions(UNIT.Event.Native.GetFilter())
	endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call dummyMissile.Destroy()

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = target

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level) * this.scale, thistype.TARGET_FILTER_EXPLOSION)

		call thistype.ENUM_GROUP.RemoveUnit(target)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = thistype.PRIMARY_DAMAGE[level]

            loop
                call caster.DamageUnitBySpell(target, damage, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call whichInstance.Destroy()
    endmethod

    condEventMethod TargetConditions_Collision
		local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = UNIT.Event.Native.GetFilter()

		local thistype this = dummyMissile.GetData()

		if this.targetGroup.Contains(target) then
			return false
		endif

		if not thistype.TargetConditions(target) then
			return false
		endif

        return true
    endmethod

	eventMethod Collision
		local Missile dummyMissile = params.Missile.GetTrigger()
		local Unit target = params.Unit.GetTrigger()

		local thistype this = dummyMissile.GetData()

		call this.targetGroup.Add(target)

		call thistype(NULL).Target.Start(this.level, target)
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
        //local real targetZ = params.Spot.GetTargetZ()

		local real targetZ = Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD

		local real scale = caster.Scale.Get()

		local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()
		local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.caster = caster
        set this.level = whichInstance.GetLevel()
        set this.scale = scale
        set this.target = target
        set this.whichInstance = whichInstance
        set this.x = caster.Position.X.Get()
        set this.y = caster.Position.Y.Get()

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, scale)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, targetZ)

		call dummyMissile.Position.AddCollision(function thistype.Collision, thistype.TARGET_FILTER_COLLISION)
    endmethod

    initMethod Init of Spells_Artifacts
    	set thistype.ENUM_GROUP = Group.Create()
    	set thistype.TARGET_FILTER_COLLISION = BoolExpr.GetFromFunction(function thistype.TargetConditions_Collision)
    	set thistype.TARGET_FILTER_EXPLOSION = BoolExpr.GetFromFunction(function thistype.TargetConditions_Explosion)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        
        call thistype(NULL).Target.Init()
    endmethod
endstruct