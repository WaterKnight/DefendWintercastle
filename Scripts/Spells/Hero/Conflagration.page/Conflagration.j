//! runtextmacro BaseStruct("Conflagration", "CONFLAGRATION")
    static real array DURATION
    static Group ENUM_GROUP
    static real array LENGTH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    real angle
    Unit caster
    real damage
    DummyUnit dummyUnit
    real length
    real lengthAdd
    integer level
    real maxLength
    UnitList targetGroup
    Timer updateTimer
    real xAdd
    real yAdd

	Lightning leftBolt
	Lightning rightBolt
	Lightning botBolt
	Lightning topBolt

	Lightning leftTotalBolt
	Lightning rightTotalBolt
	Lightning botTotalBolt
	Lightning topTotalBolt

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local DummyUnit dummyUnit = this.dummyUnit
        local UnitList targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call this.leftBolt.Destroy()
        call this.rightBolt.Destroy()
        call this.botBolt.Destroy()
        call this.topBolt.Destroy()

        call this.leftTotalBolt.Destroy()
        call this.rightTotalBolt.Destroy()
        call this.botTotalBolt.Destroy()
        call this.topTotalBolt.Destroy()

        call this.deallocate()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            //return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local real lengthAdd = this.lengthAdd
        local real maxLength = this.maxLength
        local real oldLength = this.length
        local UnitList targetGroup = this.targetGroup

        local real length = oldLength + lengthAdd
        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        local real widthEnd = thistype.WIDTH_START + (thistype.WIDTH_END - thistype.WIDTH_START) * (length / maxLength)
        local real widthStart = thistype.WIDTH_START + (thistype.WIDTH_END - thistype.WIDTH_START) * (oldLength / maxLength)

		local real botLeftX = x + widthStart * Math.Cos(angle + Math.QUARTER_ANGLE)
		local real botLeftY = y + widthStart * Math.Sin(angle + Math.QUARTER_ANGLE)
		local real botRightX = x + widthStart * Math.Cos(angle - Math.QUARTER_ANGLE)
		local real botRightY = y + widthStart * Math.Sin(angle - Math.QUARTER_ANGLE)
		
		local real xEnd = x + lengthAdd * Math.Cos(angle)
		local real yEnd = y + lengthAdd * Math.Sin(angle)
		
		local real topLeftX = xEnd + widthEnd * Math.Cos(angle + Math.QUARTER_ANGLE)
		local real topLeftY = yEnd + widthEnd * Math.Sin(angle + Math.QUARTER_ANGLE)
		local real topRightX = xEnd + widthEnd * Math.Cos(angle - Math.QUARTER_ANGLE)
		local real topRightY = yEnd + widthEnd * Math.Sin(angle - Math.QUARTER_ANGLE) 

		call this.leftBolt.Move(botLeftX, botLeftY, Spot.GetHeight(botLeftX, botLeftY), topLeftX, topLeftY, Spot.GetHeight(topLeftX, topLeftY))
		call this.rightBolt.Move(botRightX, botRightY, Spot.GetHeight(botRightX, botRightY), topRightX, topRightY, Spot.GetHeight(topRightX, topRightY))
		call this.botBolt.Move(botLeftX, botLeftY, Spot.GetHeight(botLeftX, botLeftY), botRightX, botRightY, Spot.GetHeight(botRightX, botRightY))
		call this.topBolt.Move(topLeftX, topLeftY, Spot.GetHeight(topLeftX, topLeftY), topRightX, topRightY, Spot.GetHeight(topRightX, topRightY))

        set this.length = length
        call dummyUnit.Position.SetXY(x, y)

        set User.TEMP = caster.Owner.Get()
        set UnitList.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(x, y, lengthAdd, angle, widthStart, widthEnd, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage
            local integer level = this.level

            loop
                call targetGroup.Add(target)

				local real buffDuration

				if target.Classes.Contains(UnitClass.HERO) then
					set buffDuration = thistype.BUFF_HERO_DURATION[level]
				else
					set buffDuration = thistype.BUFF_DURATION[level]
				endif

				call target.Buffs.Timed.Start(thistype.ECLIPSE_BUFF, level, buffDuration)
                call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, caster, buffDuration)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Impact
        call params.Missile.GetTrigger().Destroy()
    endmethod

    static method StartSideMissiles takes Unit source, real length, real speed, real angle returns nothing
        local Missile dummyMissile = Missile.Create()
        local real sourceX = source.Position.X.Get()
        local real sourceY = source.Position.Y.Get()

        set angle = angle - Math.QUARTER_ANGLE / 3

        local real targetX = sourceX + length * Math.Cos(angle)
        local real targetY = sourceY + length * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.5)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))

        set angle = angle + 2 * Math.QUARTER_ANGLE / 3
        set dummyMissile = Missile.Create()

        set targetX = sourceX + length * Math.Cos(angle)
        set targetY = sourceY + length * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.5)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real scale = caster.Scale.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)

		local real maxLength = thistype.MAX_LENGTH[level] * scale

		local real offset = (caster.CollisionSize.Get(false) + 0.) * scale

        local real x = casterX + offset * Math.Cos(angle)
        local real y = casterY + offset * Math.Sin(angle)

        local real d = Math.DistanceByDeltas(dX, dY)

		local thistype this = thistype.allocate()

        local Timer durationTimer = Timer.Create()
        local Sound effectSound = Sound.Create("/", true, false, false, 10, 10, SoundEax.SPELL)
        local Timer updateTimer = Timer.Create()

		local Lightning leftBolt = Lightning.Create(thistype.TOTAL_BOLT)
		local Lightning rightBolt = Lightning.Create(thistype.TOTAL_BOLT)
		local Lightning botBolt = Lightning.Create(thistype.TOTAL_BOLT)
		local Lightning topBolt = Lightning.Create(thistype.TOTAL_BOLT)

        set this.angle = angle
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x, y, caster.Position.Z.GetByCoords(x, y) + caster.Outpact.Z.Get(true), angle)
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.maxLength = maxLength
        set this.targetGroup = UnitList.Create()
        set this.updateTimer = updateTimer
        set this.xAdd = dX / d * thistype.LENGTH[level]
        set this.yAdd = dY / d * thistype.LENGTH[level]
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

		set this.leftBolt = Lightning.Create(thistype.DUMMY_BOLT)
		set this.rightBolt = Lightning.Create(thistype.DUMMY_BOLT)
		set this.botBolt = Lightning.Create(thistype.DUMMY_BOLT)
		set this.topBolt = Lightning.Create(thistype.DUMMY_BOLT)

		set this.leftTotalBolt = leftBolt
		set this.rightTotalBolt = rightBolt
		set this.botTotalBolt = botBolt
		set this.topTotalBolt = topBolt

		local real widthStart = thistype.WIDTH_START
		local real widthEnd = thistype.WIDTH_END

		local real botLeftX = x + widthStart * Math.Cos(angle + Math.QUARTER_ANGLE)
		local real botLeftY = y + widthStart * Math.Sin(angle + Math.QUARTER_ANGLE)
		local real botRightX = x + widthStart * Math.Cos(angle - Math.QUARTER_ANGLE)
		local real botRightY = y + widthStart * Math.Sin(angle - Math.QUARTER_ANGLE)
		
		local real xEnd = x + maxLength * Math.Cos(angle)
		local real yEnd = y + maxLength * Math.Sin(angle)
		
		local real topLeftX = xEnd + widthEnd * Math.Cos(angle + Math.QUARTER_ANGLE)
		local real topLeftY = yEnd + widthEnd * Math.Sin(angle + Math.QUARTER_ANGLE)
		local real topRightX = xEnd + widthEnd * Math.Cos(angle - Math.QUARTER_ANGLE)
		local real topRightY = yEnd + widthEnd * Math.Sin(angle - Math.QUARTER_ANGLE)

		call leftBolt.Move(botLeftX, botLeftY, Spot.GetHeight(botLeftX, botLeftY), topLeftX, topLeftY, Spot.GetHeight(topLeftX, topLeftY))
		call rightBolt.Move(botRightX, botRightY, Spot.GetHeight(botRightX, botRightY), topRightX, topRightY, Spot.GetHeight(topRightX, topRightY))
		call botBolt.Move(botLeftX, botLeftY, Spot.GetHeight(botLeftX, botLeftY), botRightX, botRightY, Spot.GetHeight(botRightX, botRightY))
		call topBolt.Move(topLeftX, topLeftY, Spot.GetHeight(topLeftX, topLeftY), topRightX, topRightY, Spot.GetHeight(topRightX, topRightY))

		local real duration = Math.GetMovementDuration(maxLength - lengthAdd, thistype.SPEED[level], 0.)

		call dummyUnit.SetTimeScale(0.5 / duration)
		call dummyUnit.Scale.Set(scale)
        call effectSound.SetPositionAndPlay(x, y, Spot.GetHeight(x, y))

        call effectSound.Destroy(true)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(duration, false, function thistype.Ending)

        //call thistype(NULL).StartSideMissiles(caster, thistype.MAX_LENGTH[level], thistype.SPEED[level], angle)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Eclipse.NORMAL_BUFF.Variants.Add(thistype.ECLIPSE_BUFF)
        call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DURATION[iteration] = thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]
            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct