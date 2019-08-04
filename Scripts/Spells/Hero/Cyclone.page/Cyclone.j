//! runtextmacro Folder("Cyclone")
    //! runtextmacro Struct("Relocate")
        eventMethod Event_SpellEffect
            local Unit caster = params.Unit.GetTrigger()
            local real targetX = params.Spot.GetTargetX()
            local real targetY = params.Spot.GetTargetY()

            local Unit cyclone = caster.Data.Integer.Table.GetFirst(Cyclone.KEY_ARRAY)

            call cyclone.Order.PointTarget(Order.MOVE, targetX, targetY)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Cyclone", "CYCLONE")
	static Event DESTROY_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKeyArray("KEY_ARRAY")
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

    //! runtextmacro LinkToStruct("Cyclone", "Relocate")

	Unit cyclone_caster

	eventMethod Event_Destroy
		local Unit cyclone = params.Unit.GetTrigger()

		local Unit caster = thistype(cyclone).cyclone_caster

		call cyclone.Event.Remove(DESTROY_EVENT)

		if caster.Data.Integer.Table.Remove(KEY_ARRAY, cyclone) then
			//call HeroSpell.AddToUnit(thistype.THIS_SPELL, caster)
		endif
	endmethod

    static method SpawnCyclone takes Unit caster, integer level, real x, real y returns nothing
        local Unit cyclone = Unit.CreateSummon(thistype.CYCLONE_TYPE, caster.Owner.Get(), x, y, UNIT.Facing.STANDARD, thistype.SUMMON_DURATION[level])

		set thistype(cyclone).cyclone_caster = caster
		call cyclone.Event.Add(DESTROY_EVENT)

		if caster.Data.Integer.Table.Add(KEY_ARRAY, cyclone) then
			//call HeroSpell.AddToUnit(thistype(NULL).Relocate.THIS_SPELL, caster)
		endif

        call WindDance.AddToUnit(caster, cyclone, level)
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

        call thistype(NULL).SpawnCyclone(caster, level, x, y)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local integer level = this.level
        local UnitList targetGroup = this.targetGroup

        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        set UnitList.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.CollisionSize.Get(), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage
            local real whirlDuration = thistype.WHIRL_DURATION[level]

            loop
                if not Group.TEMP.ContainsUnit(target) then
                    //call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                    call targetGroup.Add(target)

                    call caster.DamageUnitBySpell(target, damage, false, false)

					call target.Whirl.AddTimed(whirlDuration)
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

        local real length = Math.Limit(Math.DistanceByDeltas(targetY - casterY, targetX - casterX), thistype.MIN_LENGTH, thistype.MAX_LENGTH[level])

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        set targetX = casterX + length * Math.Cos(angle)
        set targetY = casterY + length * Math.Sin(angle)

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

        call dummyMissile.Acceleration.Set(0.)
        call dummyMissile.CollisionSize.Set(thistype.HIT_RANGE)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(800)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call dummyMissile.DummyUnit.LockFacing(UNIT.Facing.STANDARD)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.75)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    initMethod Init of Spells_Hero
    	set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Destroy)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Relocate.Init()
    endmethod
endstruct