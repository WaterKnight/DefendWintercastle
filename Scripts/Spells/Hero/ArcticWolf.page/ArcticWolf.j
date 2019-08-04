//! runtextmacro BaseStruct("ArcticWolf", "ARCTIC_WOLF")
    static Group ENUM_GROUP
    static BoolExpr EXPLOSION_FILTER
    static constant real INTERVAL = 0.25
    static real LENGTH
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    real angle
    real areaRange
    Unit caster
    DummyUnit dummyUnit
    DummyUnitEffect dummyUnitEffect
    Timer durationTimer
    real explosionDamage
    Timer intervalTimer
    integer level
    real stunDuration
    integer summonAmount
    real summonDuration
    UnitList targetGroup
    UnitType thisUnitType
    real travelDamage
    Timer updateTimer
    real xAdd
    real yAdd

    condMethod ExplosionConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    static method DoExplosion takes real x, real y, real areaRange, Unit caster, real damage returns nothing
        call SpotEffect.Create(x, y, thistype.EXPLOSION_EFFECT_PATH, EffectLevel.LOW)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.EXPLOSION_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local DummyUnitEffect dummyUnitEffect = this.dummyUnitEffect
        local real explosionDamage = this.explosionDamage
        local Timer intervalTimer = this.intervalTimer
        local integer summonAmount = this.summonAmount
        local real summonDuration = this.summonDuration
        local UnitList targetGroup = this.targetGroup
        local UnitType thisUnitType = this.thisUnitType
        local Timer updateTimer = this.updateTimer

        local User casterOwner = caster.Owner.Get()
        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()

        call this.deallocate()
        call dummyUnitEffect.Destroy()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call dummyUnit.DestroyTimed.Start(thistype.DUMMY_UNIT_FADE_OUT)
        call dummyUnit.VertexColor.Timed.Subtract(0., 0., 0., 127., thistype.DUMMY_UNIT_FADE_OUT)

        call thistype.DoExplosion(x, y, areaRange, caster, explosionDamage)

        loop
            exitwhen (summonAmount < 1)

            local Unit wolf = Unit.CreateSummon(thisUnitType, casterOwner, x, y, angle, summonDuration)

            set summonAmount = summonAmount - 1
        endloop
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local real areaRange = this.areaRange
        local Unit caster = this.caster
        local real damage = this.travelDamage
        local DummyUnit dummyUnit = this.dummyUnit
        local UnitList targetGroup = this.targetGroup

        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()

        set User.TEMP = caster.Owner.Get()
        set UnitList.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local integer level = this.level
            local real stunDuration = this.stunDuration

            loop
                call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, level, stunDuration)
                call targetGroup.Add(target)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        call this.dummyUnit.Position.AddXY(this.xAdd, this.yAdd)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)
        local real duration = Math.DistanceByDeltas(targetX - casterX, targetY - casterY) / thistype.SPEED

        local real partX = Math.Cos(angle)
        local real partY = Math.Sin(angle)

        local real startX = casterX + thistype.START_OFFSET * partX
        local real startY = casterY + thistype.START_OFFSET * partY

        local thistype this = thistype.allocate()

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, startX, startY, Spot.GetHeight(startX, startY) + thistype.HEIGHT, angle)
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create() 
        local Timer updateTimer = Timer.Create()

        set this.angle = angle
        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.dummyUnit = dummyUnit
        set this.dummyUnitEffect = DummyUnitEffect.Create(dummyUnit, thistype.DUMMY_UNIT_EFFECT_PATH, thistype.DUMMY_UNIT_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        set this.durationTimer = durationTimer
        set this.explosionDamage = thistype.EXPLOSION_DAMAGE[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.stunDuration = thistype.STUN_DURATION[level]
        set this.summonAmount = thistype.SUMMON_AMOUNT[level]
        set this.summonDuration = thistype.SUMMON_DURATION[level]
        set this.targetGroup = UnitList.Create()
        set this.travelDamage = thistype.TRAVEL_DAMAGE[level]
        set this.thisUnitType = thistype.SUMMON_UNIT_TYPE[level]
        set this.updateTimer = updateTimer
        set this.xAdd = thistype.LENGTH * partX
        set this.yAdd = thistype.LENGTH * partY
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call dummyUnit.Animation.SetByIndex(2)
        call dummyUnit.Scale.Set(2.)
        call dummyUnit.VertexColor.Set(255., 255., 255., 127.)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(duration, false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.EXPLOSION_FILTER = BoolExpr.GetFromFunction(function thistype.ExplosionConditions)
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct