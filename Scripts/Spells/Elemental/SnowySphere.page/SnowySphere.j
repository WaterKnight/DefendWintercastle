//! runtextmacro Folder("SnowySphere")
    //! runtextmacro Struct("Particle")
        static real array DURATION
        static Group ENUM_GROUP
        static real array LENGTH
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

        real areaRange
        Unit caster
        real damage
        DummyUnit dummyUnit
        Timer durationTimer
        UnitList targetGroup
        Timer updateTimer
        SpellInstance whichInstance
        real xAdd
        real yAdd

        timerMethod Ending
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local DummyUnit dummyUnit = this.dummyUnit
            local UnitList targetGroup = this.targetGroup
            local Timer updateTimer = this.updateTimer
            local SpellInstance whichInstance = this.whichInstance

            call this.deallocate()
            call dummyUnit.DestroyInstantly()
            call durationTimer.Destroy()
            call targetGroup.Destroy()
            call updateTimer.Destroy()
            call whichInstance.Refs.Subtract()
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
            if target.Classes.Contains(UnitClass.MECHANICAL) then
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

        timerMethod Move            
            local thistype this = Timer.GetExpired().GetData()

            local Unit caster = this.caster
            local DummyUnit dummyUnit = this.dummyUnit
            local UnitList targetGroup = this.targetGroup

            local real x = dummyUnit.Position.X.Get() + this.xAdd
            local real y = dummyUnit.Position.Y.Get() + this.yAdd

            call dummyUnit.Position.Set(x, y, dummyUnit.Position.Z.Get())

            set UnitList.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

            local Unit target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                local real damage = this.damage

                loop
                    call targetGroup.Add(target)

                    call caster.DamageUnitBySpell(target, damage, true, false)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        static method Start takes real angle, Unit caster, real damage, integer level, SpellInstance whichInstance, real x, real y, real z returns nothing
			local thistype this = thistype.allocate()

            local Timer durationTimer = Timer.Create()
            local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x, y, z, angle)
            local Timer updateTimer = Timer.Create()

            set this.areaRange = thistype.AREA_RANGE[level]
            set this.caster = caster
            set this.damage = damage
            set this.dummyUnit = dummyUnit
            set this.targetGroup = UnitList.Create()
            set this.updateTimer = updateTimer
            set this.xAdd = thistype.LENGTH[level] * Math.Cos(angle)
            set this.yAdd = thistype.LENGTH[level] * Math.Sin(angle)
            set this.whichInstance = whichInstance
            call durationTimer.SetData(this)
            call updateTimer.SetData(this)
            call whichInstance.Refs.Add()

            call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

            call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

            local integer iteration = SnowySphere.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DURATION[iteration] = thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]
                set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SnowySphere", "SNOWY_SPHERE")
    static real array DURATION
    static real array LENGTH
    static real array SPAWN_ANGLE_ADD
    static real array SPAWN_INTERVAL
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damage
    DummyUnit dummyUnit
    Timer intervalTimer
    integer level
    real spawnAngle
    real spawnAngleAdd
    real spawnXOffset
    real spawnYOffset
    Timer updateTimer
    SpellInstance whichInstance
    real x
    real y
    real xAdd
    real yAdd

    //! runtextmacro LinkToStruct("SnowySphere", "Particle")

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer intervalTimer = this.intervalTimer
        local Timer updateTimer = this.updateTimer
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call updateTimer.Destroy()
        call whichInstance.Destroy()
    endmethod

    timerMethod SpawnParticle
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.spawnAngle + this.spawnAngleAdd
        local DummyUnit dummyUnit = this.dummyUnit

        set this.spawnAngle = angle
        call thistype(NULL).Particle.Start(angle, this.caster, this.damage, this.level, this.whichInstance, dummyUnit.Position.X.Get() + this.spawnXOffset, dummyUnit.Position.Y.Get() + this.spawnYOffset, dummyUnit.Position.Z.Get())
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local DummyUnit dummyUnit = this.dummyUnit

        call dummyUnit.Position.Set(dummyUnit.Position.X.Get() + this.xAdd, dummyUnit.Position.Y.Get() + this.yAdd, dummyUnit.Position.Z.Get())
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real casterZ = caster.Position.Z.Get() + caster.Outpact.Z.Get(true)

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        local real xPart = Math.Cos(angle)
        local real yPart = Math.Sin(angle)

        local thistype this = thistype.allocate()

		local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, casterZ, angle)
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local Timer updateTimer = Timer.Create()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.caster = caster
        set this.damage = Particle.DAMAGE[level]
        set this.dummyUnit = dummyUnit
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.spawnAngle = angle
        set this.spawnAngleAdd = thistype.SPAWN_ANGLE_ADD[level]
        set this.spawnXOffset = thistype.SPAWN_OFFSET * xPart
        set this.spawnYOffset = thistype.SPAWN_OFFSET * yPart
        set this.updateTimer = updateTimer
        set this.whichInstance = whichInstance
        set this.xAdd = thistype.LENGTH[level] * xPart
        set this.yAdd = thistype.LENGTH[level] * yPart
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call intervalTimer.Start(thistype.SPAWN_INTERVAL[level], true, function thistype.SpawnParticle)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Purchasable
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DURATION[iteration] = thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]
            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

            set thistype.SPAWN_INTERVAL[iteration] = thistype.DURATION[iteration] / thistype.SPAWN_AMOUNT[iteration]

            set thistype.SPAWN_ANGLE_ADD[iteration] = thistype.SPAWN_ANGLE_MAX_ADD[iteration] * thistype.SPAWN_INTERVAL[iteration] / thistype.DURATION[iteration]

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Particle.Init()
    endmethod
endstruct