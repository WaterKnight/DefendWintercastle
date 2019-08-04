//! runtextmacro Folder("BoulderCrash")
    //! runtextmacro Struct("Visuals")
        DummyUnit areaDummy
        Unit caster
        Timer intervalTimer
        integer level

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            call dummyMissile.Destroy()
        endmethod

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit caster = this
            local integer level = this.level

            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real casterZ = caster.Position.Z.Get()

            local real acceleration = S2R(SetVar.GetValDef("acc", "200."))//200.
            local real angle = Math.RandomAngle()
            local real dist = BoulderCrash.THIS_SPELL.GetAreaRange(level) * S2R(SetVar.GetValDef("distFactor", "0.75"))
            local real height = Math.Random(330., 520.)
            local real scale = Math.Random(0.5, 1.)
            local real speed = S2R(SetVar.GetValDef("speed", "300."))//200.//Math.Random(600., 700.)

            local real duration = Math.GetMovementDuration(dist, speed, acceleration)

			local Missile dummyMissile = Missile.Create()

            call dummyMissile.Acceleration.Set(acceleration)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.Speed.Set(speed)
            call dummyMissile.Speed.SetMin(100.)
            call dummyMissile.Position.Set(casterX + dist * Math.Cos(angle), casterY + dist * Math.Sin(angle), casterZ + height)

            call dummyMissile.GoToSpot.Start(casterX, casterY, casterZ)

            call dummyMissile.DummyUnit.LockFacing(UNIT.Facing.STANDARD)

			local DummyUnit dummyUnit

            if (Math.RandomI(0, 1) == 0) then
                set dummyUnit = dummyMissile.DummyUnit.Create(thistype.TREE_ID, scale)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            else
                set dummyUnit = dummyMissile.DummyUnit.Create(thistype.STONE_ID, scale)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            endif

            call dummyMissile.CollisionSize.Set(64.)

            call dummyUnit.VertexColor.Set(255., 255., 255., S2R(SetVar.GetValDef("alpha", "200.")))
            call dummyUnit.VertexColor.Timed.Subtract(0, 0, 0, dummyUnit.VertexColor.Alpha.Get(), duration * S2R(SetVar.GetValDef("durFactor", "0.9")))
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local DummyUnit areaDummy = this.areaDummy
            local Timer intervalTimer = this.intervalTimer

            call areaDummy.Destroy()
            call intervalTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local DummyUnit areaDummy = DummyUnit.Create(thistype.AREA_DUMMY_ID, target.Position.X.Get(), target.Position.Y.Get(), target.Position.Z.Get(), target.Facing.Get())
			local Timer intervalTimer = Timer.Create()

            set this.areaDummy = areaDummy
            set this.intervalTimer = intervalTimer
            set this.level = level
            call intervalTimer.SetData(this)

            call areaDummy.FollowUnit.Start(target, false, false, 0., 0., 0.)

            call intervalTimer.StartPeriodicRange(thistype.INTERVAL_MIN, thistype.INTERVAL_MAX, function thistype.Interval)
        endmethod

        method Ending takes Unit caster returns nothing
            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        method Start takes Unit caster, integer level returns nothing
            call caster.Buffs.Add(thistype.DUMMY_BUFF, level)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("BoulderCrash", "BOULDER_CRASH")
	static real array DAMAGE_PER_INTERVAL
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    integer level
    Timer intervalTimer

    //! runtextmacro LinkToStruct("BoulderCrash", "Visuals")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
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

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local integer level = this.level

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real colSize = caster.CollisionSize.Get(true)

        local real minPullRange = colSize

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = thistype.DAMAGE_PER_INTERVAL[level]

            loop
                local real d = Math.DistanceByDeltas(target.Position.X.Get() - casterX, target.Position.Y.Get() - casterY)

                local real rangeFactor = Math.Shapes.LinearFromCoords(colSize, thistype.RANGE_FACTOR_CLOSE, areaRange, thistype.RANGE_FACTOR_FAR, d)

                local real pullDuration = Math.GetMovementDuration(d - minPullRange, thistype.PULL_SPEED[level], 0.)

                call target.Position.Timed.AddSpeedDirection(thistype.PULL_SPEED[level], Math.AtanByDeltas(casterY - target.Position.Y.Get(), casterX - target.Position.X.Get()), pullDuration)

                call caster.DamageUnitBySpell(target, damage * rangeFactor, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()

        call thistype(NULL).Visuals.Ending(target)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = Timer.Create()

        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call thistype(NULL).Visuals.Start(target, level)
    endmethod

    eventMethod Event_EndCast
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

		local integer level = thistype.THIS_SPELL.GetLevelsAmount()

		loop
			exitwhen (level < 1)

			set thistype.DAMAGE_PER_INTERVAL[level] = thistype.DAMAGE_PER_SECOND[level] * thistype.INTERVAL

			set level = level - 1
		endloop

        call thistype(NULL).Visuals.Init()
    endmethod
endstruct