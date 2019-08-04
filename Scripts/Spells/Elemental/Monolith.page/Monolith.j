//! runtextmacro BaseStruct("Monolith", "MONOLITH")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damage
    Missile dummyMissile
    integer level
    UnitList targetGroup
    real targetX
    real targetY
    Timer updateTimer

    static method SpawnMonolith takes Unit caster, integer level, real x, real y returns nothing
        local Unit monolith = Unit.CreateSummon(thistype.MONOLITH_TYPE, caster.Owner.Get(), x, y, UNIT.Facing.STANDARD, thistype.SUMMON_DURATION[level])

        call SacredAura.AddAbility(monolith, caster, level)
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Timer updateTimer = this.updateTimer
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        call this.deallocate()
        call dummyMissile.Destroy()
        call updateTimer.Destroy()

        call thistype(NULL).SpawnMonolith(caster, level, x, y)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

		if (target == Unit.TEMP) then
			return false
		endif

        if UnitList.TEMP.Contains(target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif

        return true
    endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local UnitList targetGroup = this.targetGroup

		local User casterOwner = caster.Owner.Get()
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

		set Unit.TEMP = caster
        set User.TEMP = casterOwner
        set UnitList.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get(), dummyMissile.CollisionSize.Get(), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage

            loop
                call targetGroup.Add(target)

                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
				call target.Position.Timed.Accelerated.AddKnockback(dummyMissile.Speed.Get(), dummyMissile.Acceleration.Get(), Math.AtanByDeltas(target.Position.Y.Get() - y, target.Position.X.Get() - x), 1.)

				if not target.IsAllyOf(casterOwner) then
                	call caster.DamageUnitBySpell(target, damage, false, false)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
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
        set this.damage = thistype.DAMAGE[level]
        set this.dummyMissile = dummyMissile
        set this.level = level
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this) 

		//2*maxLength/speed=t
		//-speed/t=acc -> acc=-speed*speed/(2*maxLength)
		local real maxLengthEpsilon = 1.
		local real speed = 800.
		
		local real acc = -speed * speed / (2 * (maxLength + maxLengthEpsilon))

        call dummyMissile.Acceleration.Set(acc)
        call dummyMissile.CollisionSize.Set(thistype.HIT_RANGE)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call dummyMissile.DummyUnit.LockFacing(UNIT.Facing.STANDARD)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.75)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct