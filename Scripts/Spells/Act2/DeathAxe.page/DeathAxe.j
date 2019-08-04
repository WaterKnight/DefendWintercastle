//! runtextmacro BaseStruct("DeathAxe", "DEATH_AXE")
    static Event DEATH_EVENT
    static BoolExpr MISSILE_TARGET_FILTER
    static BoolExpr TARGET_FILTER

    Unit caster
    real damage
    Timer delayTimer
    integer level

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.NEUTRAL) then
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

    condEventMethod Missile_TargetConditions
		local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        set User.TEMP = this.caster.Owner.Get()

        if not thistype.TargetConditions() then
            return false
        endif

        return true
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        if (target == NULL) then
            call this.deallocate()
            call dummyMissile.Destroy()

            return
        endif

        local Unit caster = this.caster
        local real damage = this.damage

        call this.deallocate()
        call dummyMissile.Destroy()

        if target.MagicImmunity.Try() then
            return
        endif

        call caster.DamageUnitBySpell(target, damage, true, false)

        call target.Buffs.Timed.Start(UNIT.Attack.NORMAL_BUFF, this.level, thistype.DISARM_DURATION)
    endmethod

    timerMethod Delay
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        local Unit caster = this.caster
        local integer level = this.level

        local real startX = caster.Position.X.Get()
        local real startY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)

        call delayTimer.Destroy()

        set User.TEMP = caster.Owner.Get()

        local Unit target = GROUP.EnumUnits.InRange.WithCollision.GetNearest(startX, startY, thistype.THIS_SPELL.GetRange(level), thistype.TARGET_FILTER)

        if (target == NULL) then
            call this.deallocate()
        else
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = Math.AtanByDeltas(targetY - startY, targetX - startX)

			local Missile dummyMissile = Missile.Create()

            local DummyUnit dummyUnit = dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5)

            call dummyMissile.Acceleration.Set(500.)
            call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(350.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyUnit.AddEffect(thistype.DUMMY_EFFECT_PATH, thistype.DUMMY_EFFECT_ATTACH_POINT, EffectLevel.LOW)

            call dummyMissile.Impact.SetFilter(thistype.MISSILE_TARGET_FILTER)
            call dummyMissile.GoToSpot.Start(startX + maxLength * Math.Cos(angle), startY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)
        endif

        call caster.Refs.Subtract()
    endmethod

    static method Start takes Unit caster, integer level returns nothing
        local thistype this = thistype.allocate()

		local Timer delayTimer = Timer.Create()

        set this.caster = caster
        set this.damage = thistype.DAMAGE
        set this.delayTimer = delayTimer
        set this.level = level
        call delayTimer.SetData(this)

        call caster.Refs.Add()

        call delayTimer.Start(thistype.DELAY, false, function thistype.Delay)
    endmethod

    eventMethod Event_Death
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        call thistype.Start(caster, level)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Event.Remove(DEATH_EVENT)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    initMethod Init of Spells_Act2
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.MISSILE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Missile_TargetConditions)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct