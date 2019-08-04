//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("ArcticWolf", "ARCTIC_WOLF")
    static string DUMMY_UNIT_EFFECT_ATTACH_POINT
    static string DUMMY_UNIT_EFFECT_PATH
    static real DUMMY_UNIT_FADE_OUT
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dArW", "Arctic Wolf", "DUMMY_UNIT_ID", "units\\orc\\Spiritwolf\\Spiritwolf.mdl")
    static Group ENUM_GROUP
    static real HEIGHT
    static real LENGTH
    static real SPEED
    static real START_OFFSET
    static real array STUN_DURATION
    static real array SUMMON_DURATION
    static UnitType array SUMMON_UNIT_TYPE
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    static Spell THIS_SPELL

    real angle
    real areaRange
    Unit caster
    DummyUnit dummyUnit
    DummyUnitEffect dummyUnitEffect
    Timer durationTimer
    real stunDuration
    real summonDuration
    Group targetGroup
    UnitType thisUnitType
    Timer updateTimer
    real xAdd
    real yAdd

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()
        local Unit wolf

        local thistype this = durationTimer.GetData()

        local real angle = this.angle
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local DummyUnitEffect dummyUnitEffect = this.dummyUnitEffect
        local real summonDuration = this.summonDuration
        local Group targetGroup = this.targetGroup
        local UnitType thisUnitType = this.thisUnitType
        local Timer updateTimer = this.updateTimer

        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()

        call this.deallocate()
        call dummyUnitEffect.Destroy()
        call durationTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call dummyUnit.DestroyTimed.Start(thistype.DUMMY_UNIT_FADE_OUT)
        call dummyUnit.VertexColor.Timed.Subtract(0., 0., 0., 127., thistype.DUMMY_UNIT_FADE_OUT)

        set wolf = Unit.CreateSummon(thisUnitType, caster.Owner.Get(), x, y, angle, summonDuration)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(filterUnit)) then
            return false
        endif

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method Move takes nothing returns nothing
        local real stunDuration
        local Unit target
        local real targetX
        local real targetY
        local thistype this = Timer.GetExpired().GetData()

        local real areaRange = this.areaRange
        local Unit caster = this.caster
        local DummyUnit dummyUnit = this.dummyUnit
        local Group targetGroup = this.targetGroup
        local real x = dummyUnit.Position.X.Get() + this.xAdd
        local real y = dummyUnit.Position.Y.Get() + this.yAdd

        call dummyUnit.Position.X.Set(x)
        call dummyUnit.Position.Y.Set(y)

        call dummyUnit.Position.Z.UpdateByCoords(x, y)

        set User.TEMP = caster.Owner.Get()
        set Group.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set stunDuration = this.stunDuration

            loop
                call target.Stun.AddTimed(stunDuration, UNIT.Stun.NORMAL_BUFF)
                call targetGroup.AddUnit(target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local DummyUnit dummyUnit
        local Timer durationTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local real partX
        local real partY
        local real startX
        local real startY
        local Group targetGroup = Group.Create()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()
        local Timer updateTimer = Timer.Create()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)
        local real duration = Math.DistanceByDeltas(targetX - casterX, targetY - casterY) / thistype.SPEED

        set partX = Math.Cos(angle)
        set partY = Math.Sin(angle)
        set startX = casterX + thistype.START_OFFSET * partX
        set startY = casterY + thistype.START_OFFSET * partY
        set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, startX, startY, Spot.GetHeight(startX, startY) + thistype.HEIGHT, angle)

        set this.angle = angle
        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.dummyUnit = dummyUnit
        set this.dummyUnitEffect = DummyUnitEffect.Create(dummyUnit, thistype.DUMMY_UNIT_EFFECT_PATH, thistype.DUMMY_UNIT_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        set this.durationTimer = durationTimer
        set this.stunDuration = thistype.STUN_DURATION[level]
        set this.summonDuration = thistype.SUMMON_DURATION[level]
        set this.targetGroup = targetGroup
        set this.thisUnitType = thistype.SUMMON_UNIT_TYPE[level]
        set this.updateTimer = updateTimer
        set this.xAdd = thistype.LENGTH * partX
        set this.yAdd = thistype.LENGTH * partY
        call durationTimer.SetData(this)
        call updateTimer.SetData(this)

        call dummyUnit.Animation.SetByIndex(2)
        call dummyUnit.Scale.Set(2.)
        call dummyUnit.VertexColor.Set(255., 255., 255., 127.)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

        call durationTimer.Start(duration, false, function thistype.Ending)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_ArcticWolf.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct