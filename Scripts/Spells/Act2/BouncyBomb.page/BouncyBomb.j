//! runtextmacro BaseStruct("BouncyBomb", "BOUNCY_BOMB")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
    static integer WAVES_AMOUNT
    static real Z_ADD_ADD

    Unit caster
    Unit dummyUnit
    real length
    real targetX
    real targetY
    Timer updateTimer
    SpellInstance whichInstance
    real xAdd
    real yAdd
    real zAdd
    real zAddAdd

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
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

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local Timer updateTimer = this.updateTimer
        local SpellInstance whichInstance = this.whichInstance

        local integer level = whichInstance.GetLevel()
        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()
        local real z = dummyUnit.Position.Z.Get()

        call this.deallocate()
        call dummyUnit.Destroy()
        call durationTimer.Destroy()
        call updateTimer.Destroy()

        call Spot.CreateEffectWithZ(x, y, z, thistype.EXPLOSION_EFFECT_PATH, EffectLevel.LOW).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(x, y, z, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real maxDamage = thistype.MAX_DAMAGE

            loop
                local real damage = Math.Min(thistype.DAMAGE, maxDamage)

                set maxDamage = maxDamage - damage
                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call whichInstance.Destroy()
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local DummyUnit dummyUnit = this.dummyUnit

        local real zAdd = this.zAdd + thistype.Z_ADD_ADD

        call dummyUnit.Position.Add(this.xAdd, this.yAdd, zAdd)

        if (dummyUnit.Position.Z.GetFlyHeight() < thistype.FLOOR_TOLERANCE) then
            set this.zAdd = Math.Abs(zAdd)
        else
            set this.zAdd = zAdd
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

		local thistype this = thistype.allocate()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real casterZ = caster.Position.Z.Get() + caster.Outpact.Z.Get(true)
		local Timer durationTimer = Timer.Create()
		local Timer updateTimer = Timer.Create()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        local real dX = targetX - caster.Position.X.Get()
        local real dY = targetY - caster.Position.Y.Get()

        local real angle = caster.CastAngle(dX, dY)
        local real d = Math.DistanceByDeltas(dX, dY)

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, casterZ, angle)
        local real lengthXY = d / thistype.WAVES_AMOUNT

        local real lengthX = lengthXY * Math.Cos(angle)
        local real lengthY = lengthXY * Math.Sin(angle)
        local real lengthZ = ((Spot.GetHeight(targetX, targetY) - casterZ) / thistype.FIRST_BOUNCE_DURATION - thistype.Z_ACCELERATION / 2 * thistype.FIRST_BOUNCE_DURATION) * thistype.UPDATE_TIME

        set this.caster = caster
        set this.dummyUnit = dummyUnit
        set this.length = Math.DistanceByDeltasWithZ(lengthX, lengthY, lengthZ)
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        set this.whichInstance = whichInstance
        set this.xAdd = lengthX
        set this.yAdd = lengthY
        set this.zAdd = lengthZ
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(thistype.EXPLOSION_DURATION, false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Act2
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.EXPLOSION_DURATION / thistype.UPDATE_TIME)
        set thistype.Z_ADD_ADD = thistype.Z_ACCELERATION * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct