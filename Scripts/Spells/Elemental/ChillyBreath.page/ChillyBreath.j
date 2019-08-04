//! runtextmacro Folder("ChillyBreath")
    //! runtextmacro Struct("Buff")
        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Madness.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ChillyBreath", "CHILLY_BREATH")
    static constant real DUMMY_UNIT_STANDARD_DURATION = 0.35
    static Group ENUM_GROUP
    static real array LENGTH
    static real array SPEED
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
    Missile missileLeft
    Missile missileRight
    Group targetGroup
    Queue tiles
    Timer updateTimer
    real xAdd
    real yAdd

    //! runtextmacro LinkToStruct("ChillyBreath", "Buff")

    method Ending takes nothing returns nothing
        local DummyUnit dummyUnit = this.dummyUnit
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer
call DebugEx("destroy "+I2S(this)+";"+I2S(updateTimer))
		call dummyUnit.SetTimeScale(1.)
        call dummyUnit.Destroy()
        call targetGroup.Destroy()
        call this.tiles.Destroy()
        call updateTimer.Destroy()

		call this.missileLeft.DummyUnit.Get().SetTimeScale(1.)
        call this.missileLeft.Destroy()
        call this.missileRight.DummyUnit.Get().SetTimeScale(1.)
        call this.missileRight.Destroy()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if Group.TEMP.ContainsUnit(target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
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

    method SpawnIce takes real x, real y returns nothing
        local Tile val = Tile.GetFromCoords(x, y)

        if this.tiles.Contains(val) then
            call val.RemoveRef()

            return
        endif

		call this.tiles.Add(val)

        call TileTypeMod.Create(x, y, TileType.ICE).DestroyTimed.Start(4.)
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local real lengthAdd = this.lengthAdd
        local real maxLength = this.maxLength
        local real oldLength = this.length
        local Group targetGroup = this.targetGroup

        local real length = oldLength + lengthAdd
        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        local real widthEnd = thistype.WIDTH_START + (thistype.WIDTH_END - thistype.WIDTH_START) * (oldLength / maxLength)
        local real widthStart = thistype.WIDTH_START + (thistype.WIDTH_END - thistype.WIDTH_START) * (length / maxLength)

        call this.SpawnIce(x, y)
        call this.SpawnIce(this.missileLeft.Position.X.Get(), this.missileLeft.Position.Y.Get())
        call this.SpawnIce(this.missileRight.Position.X.Get(), this.missileRight.Position.Y.Get())

        set this.length = length
        call dummyUnit.Position.SetXY(x, y)

        set User.TEMP = caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(x, y, lengthAdd, angle, widthStart, widthEnd, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage * (1 + length / maxLength * thistype.DAMAGE_RANGE_FACTOR)
            local integer level = this.level

            loop
                call targetGroup.AddUnit(target)

                call thistype(NULL).Buff.Start(level, target)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Impact
        //call params.Missile.GetTrigger().Destroy()
    endmethod

    method StartSideMissiles takes Unit source, real length, real speed, real angle, real timeScale returns nothing
        local real sourceX = source.Position.X.Get()
        local real sourceY = source.Position.Y.Get()

		local Missile dummyMissile = Missile.Create()

        set this.missileRight = dummyMissile

        set angle = angle - Math.QUARTER_ANGLE / 3

        local real targetX = sourceX + length * Math.Cos(angle)
        local real targetY = sourceY + length * Math.Sin(angle)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.4)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        local DummyUnit dummyUnit = dummyMissile.DummyUnit.Get()

        call dummyUnit.SetTimeScale(timeScale)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))

        set angle = angle + 2 * Math.QUARTER_ANGLE / 3
        set dummyMissile = Missile.Create()

        set targetX = sourceX + length * Math.Cos(angle)
        set targetY = sourceY + length * Math.Sin(angle)

        set this.missileLeft = dummyMissile

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.4).SetTimeScale(timeScale)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(speed)
        call dummyMissile.Position.SetFromUnit(source)

        set dummyUnit = dummyMissile.DummyUnit.Get()

        call dummyUnit.SetTimeScale(timeScale)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster

        call this.Ending()

        if success then
            call caster.Abilities.Refresh(Infection.THIS_SPELL)
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY
        local real timeScale = thistype.DUMMY_UNIT_STANDARD_DURATION / thistype.THIS_SPELL.GetChannelTime(level)

        local real angle = caster.CastAngle(dX, dY)

        local thistype this = caster

		local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), angle)
		local Sound effectSound = Sound.CreateFromType(thistype.EFFECT_SOUND)
        local Timer updateTimer = Timer.Create()

call DebugEx("create "+I2S(this)+";"+I2S(updateTimer))
        set this.angle = angle
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyUnit = dummyUnit
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.maxLength = thistype.MAX_LENGTH[level]
        set this.targetGroup = Group.Create()
        set this.tiles = Queue.Create()
        set this.updateTimer = updateTimer
        set this.xAdd = Math.Cos(angle) * thistype.LENGTH[level]
        set this.yAdd = Math.Sin(angle) * thistype.LENGTH[level]
        call updateTimer.SetData(this)

        call dummyUnit.SetScale(0.75)
        call dummyUnit.SetTimeScale(timeScale)
        call effectSound.SetPositionAndPlay(casterX, casterY, Spot.GetHeight(casterX, casterY))

        call effectSound.Destroy(true)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call this.StartSideMissiles(caster, thistype.MAX_LENGTH[level], thistype.SPEED[level], angle, timeScale)

        call caster.Knockup.Start()
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.SPEED[iteration] = thistype.MAX_LENGTH[iteration] / thistype.THIS_SPELL.GetChannelTime(iteration)

            set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Buff.Init()
    endmethod
endstruct