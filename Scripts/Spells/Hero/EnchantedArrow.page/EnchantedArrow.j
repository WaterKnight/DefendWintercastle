//! runtextmacro BaseStruct("EnchantedArrow", "ENCHANTED_ARROW")
	static UnitList DIFFERENCE_GROUP
    static Group ENUM_GROUP
    static Event MISSILE_DESTROY_EVENT
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damage
    Missile dummyMissile
    integer level
    real stunDuration
    UnitList targetGroup
    real targetX
    real targetY
    Timer updateTimer

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        /*if UnitList.TEMP.Contains(target) then
            return false
        endif*/

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

	method DoExplosion takes Unit caster, integer level, real x, real y returns nothing
		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
		
		call Spot.CreateEffectWithSize(x, y, thistype.EXPLOSION_EFFECT_PATH, EffectLevel.LOW, areaRange / thistype.EXPLOSION_EFFECT_SCALE_FACTOR).Destroy()
		
        set User.TEMP = caster.Owner.Get()
        
        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, 2 * areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage
            local real stunDuration = this.stunDuration
            
            loop
            	call target.Stun.AddTimedBy(UNIT.Stun.NORMAL_BUFF, stunDuration)
            	
            	call caster.DamageUnitBySpell(target, damage, true, false)
            	
                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
	endmethod

	method ClearTargetGroup takes nothing returns nothing
		local UnitList targetGroup = this.targetGroup
		
		loop
			local Unit target = targetGroup.FetchFirst()
			exitwhen (target == NULL)
			
			call target.Movement.Add()
		endloop
	endmethod

    eventMethod Event_Destroy
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

		local Unit caster = this.caster
		local integer level = this.level
        local Timer updateTimer = this.updateTimer
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        call updateTimer.Destroy()

		call dummyMissile.Event.Remove(MISSILE_DESTROY_EVENT)
        
        call this.deallocate()
    endmethod

	eventMethod Impact
		local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

		local Unit caster = this.caster
		local integer level = this.level
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

		call dummyMissile.Destroy()

		call this.DoExplosion(caster, level, x, y)
	endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local UnitList targetGroup = this.targetGroup
        local real targetX = this.targetX
        local real targetY = this.targetY

        set UnitList.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

		local real missileX = dummyMissile.Position.X.Get()
		local real missileY = dummyMissile.Position.Y.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(missileX, missileY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

		call targetGroup.GetDifferenceGroupEx(thistype.ENUM_GROUP, thistype.DIFFERENCE_GROUP)

		loop
			local Unit target = thistype.DIFFERENCE_GROUP.FetchFirst()
			exitwhen (target == NULL)
			
			call targetGroup.Remove(target)
			
			call target.Movement.Add()
		endloop

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then            
            local real angle = dummyMissile.Angle.GetXY()
            local real speed = dummyMissile.Speed.Get()
            local real updateTime = dummyMissile.UpdateTime.Get()

			local real lengthX = speed * thistype.UPDATE_TIME * Math.Cos(angle)
			local real lengthY = speed * thistype.UPDATE_TIME * Math.Sin(angle)

            loop
                if not targetGroup.Contains(target) then
                    call targetGroup.Add(target)
                    
                    call target.Movement.Subtract()
                endif
                
               	local real newX = target.Position.X.Get() + lengthX
                local real newY = target.Position.Y.Get() + lengthY
                
                if not Spot.IsBlocked(newX, newY) then
                	call target.Position.SetXY(newX, newY)
                endif
                
                //call targetGroup.AddUnit(target)

                //call caster.DamageUnitBySpell(target, damage, false, true)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
        
        if Spot.IsBlocked(missileX, missileY) then
            call dummyMissile.Impact.DoCur()
        endif
    endmethod

	thistype caster_this

	eventMethod Event_EndCast
		local Unit caster = params.Unit.GetTrigger()
		local integer level = params.Spell.GetLevel()
		local boolean success = params.Spell.IsChannelComplete()
		
		local thistype this = thistype(caster).caster_this
		
		if not success then
			call this.dummyMissile.Destroy()

			call caster.Abilities.Refresh(thistype.THIS_SPELL)
			call caster.Mana.Add(thistype.THIS_SPELL.GetManaCost(level))
			
			return
		endif

		local real targetX = this.targetX
		local real targetY = this.targetY
		
		call this.dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)
		
		call this.updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.MAX_LENGTH[level]

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        set targetX = casterX + maxLength * Math.Cos(angle)
        set targetY = casterY + maxLength * Math.Sin(angle)

		local thistype this = thistype.allocate()

        local Missile dummyMissile = Missile.Create()
        local Timer updateTimer = Timer.Create()

        set this.caster = caster
        set this.damage = thistype.DAMAGE[level] + thistype.DAMAGE_PER_FOCUS[level]
        set this.dummyMissile = dummyMissile
        set this.level = level
        set this.stunDuration = thistype.STUN_DURATION[level]
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

		call dummyMissile.Event.Add(MISSILE_DESTROY_EVENT)

        call dummyMissile.Acceleration.Set(400.)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1100.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.DummyUnit.CreateWithAngle(thistype.DUMMY_UNIT_ID, 0., Math.AtanByDeltas(targetY - casterY, targetX - casterX)).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

		call dummyMissile.DummyUnit.Get().AddEffect(thistype.MISSILE_EFFECT2_PATH, thistype.MISSILE_EFFECT2_ATTACH_POINT, EffectLevel.NORMAL)
		
		call dummyMissile.DummyUnit.Get().Scale.Timed.Add(5., thistype.THIS_SPELL.GetChannelTime(level))
		
		set thistype(caster).caster_this = this
    endmethod

    initMethod Init of Spells_Hero
    	set thistype.DIFFERENCE_GROUP = UnitList.Create()
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.MISSILE_DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Destroy)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
    endmethod
endstruct