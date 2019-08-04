//! runtextmacro BaseStruct("Conflagration", "CONFLAGRATION")
    static real array DAMAGE
    static real array DURATION
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dCon", "Conflagration", "DUMMY_UNIT_ID", "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdl")
    static Group ENUM_GROUP
    static real array IGNITION_DURATION
    static real OFFSET
    static real array LENGTH
    static real array MAX_LENGTH
    static real array SPEED
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
    static real WIDTH_END
    static real WIDTH_START

    static Spell THIS_SPELL

    //! import "Spells\Hero\Conflagration\obj.j"

    real angle
    Unit caster
    real damage
    DummyUnit dummyUnit
    real length
    real lengthAdd
    integer level
    real maxLength
    Group targetGroup
    Timer updateTimer
    real xAdd
    real yAdd

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer updateTimer = this.updateTimer

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Move takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local real damage = this.damage
        local DummyUnit dummyUnit = this.dummyUnit
        local real lengthAdd = this.lengthAdd
        local real maxLength = this.maxLength
        local real oldLength = this.length
        local Group targetGroup = this.targetGroup

        local real length = oldLength + lengthAdd
        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        local real widthEnd = thistype.WIDTH_END + (thistype.WIDTH_END - thistype.WIDTH_START) * (length / maxLength)
        local real widthStart = thistype.WIDTH_END + (thistype.WIDTH_END - thistype.WIDTH_START) * (oldLength / maxLength)

        set this.length = length
        call dummyUnit.Position.SetXY(x, y)

        set User.TEMP = caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(x, y, lengthAdd, angle, widthStart, widthEnd, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set damage = this.damage
            set level = this.level

            loop
                call targetGroup.AddUnit(target)

                call target.Ignited.AddTimed(caster, thistype.IGNITION_DURATION[level])

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Impact takes nothing returns nothing
        call MISSILE.Event.GetTrigger().Destroy()
    endmethod

    static method StartSideMissiles takes Unit source, real length, real speed, real angle returns nothing
        local Missile dummyMissile = Missile.Create()
        local real sourceX = source.Position.X.Get()
        local real sourceY = source.Position.Y.Get()
        local real targetX
        local real targetY

        set angle = angle - Math.QUARTER_ANGLE / 3

        set targetX = sourceX + length * Math.Cos(angle)
        set targetY = sourceY + length * Math.Sin(angle)

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

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local real d
        local Timer durationTimer = Timer.Create()
        local Sound effectSound = Sound.Create("/", true, false, false, 10, 10, SoundEax.SPELL)
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real angle = caster.CastAngle(dX, dY)

        set casterX = casterX + thistype.OFFSET * Math.Cos(angle)
        set casterY = casterY + thistype.OFFSET * Math.Sin(angle)

        set d = Math.DistanceByDeltas(dX, dY)

        set this.angle = angle
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.GetByCoords(casterX, casterY) + caster.Outpact.Z.Get(true), angle)
        set this.length = 0.
        set this.lengthAdd = thistype.LENGTH[level]
        set this.level = level
        set this.maxLength = thistype.MAX_LENGTH[level]
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        set this.xAdd = dX / d * thistype.LENGTH[level]
        set this.yAdd = dY / d * thistype.LENGTH[level]
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call effectSound.SetPositionAndPlay(casterX, casterY, Spot.GetHeight(casterX, casterY))

        call effectSound.Destroy(true)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)

        //call thistype(NULL).StartSideMissiles(caster, thistype.MAX_LENGTH[level], thistype.SPEED[level], angle)
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DURATION[iteration] = thistype.MAX_LENGTH[iteration] / thistype.SPEED[iteration]
                set thistype.LENGTH[iteration] = thistype.SPEED[iteration] * thistype.UPDATE_TIME

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
    endmethod
endstruct