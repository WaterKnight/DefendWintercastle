//! runtextmacro BaseStruct("StoneShield", "STONE_SHIELD")
    static constant real DIST_ADD_PER_SECOND = -500.
    static constant real DURATION_FOR_FULL_ANGLE = 0.9
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    real angle
    real angleAdd
    UnitModSet armorMod
    real damagePerInterval
    real distAdd
    DummyUnit dummyUnit
    real length
    integer level
    integer powerLevel
    Timer updateTimer
    Timer weakenTimer
    real x
    real y

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

	method DealDamage takes nothing returns nothing
		local Unit caster = this
		local DummyUnit dummyUnit = this.dummyUnit

		local real x = dummyUnit.Position.X.Get()
		local real y = dummyUnit.Position.Y.Get()
		local real z = dummyUnit.Position.Z.Get()

		call SpotEffect.CreateWithZ(x, y, z, thistype.EXPLOSION_EFFECT_PATH, EffectLevel.LOW).Destroy()

		set User.TEMP = caster.Owner.Get()

		call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(x, y, z, thistype.HIT_RANGE, thistype.TARGET_FILTER)

		local Unit target = thistype.ENUM_GROUP.FetchFirst()

		if (target != NULL) then
			local real damage = this.damagePerInterval

            loop
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call caster.DamageUnitBySpell(target, damage, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
		endif
	endmethod

	timerMethod Interval
		local thistype this = Timer.GetExpired().GetData()

		
	endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local DummyUnit dummyUnit = this.dummyUnit
        local Unit target = this

        local real x = dummyUnit.Position.X.Get()
        local real y = dummyUnit.Position.Y.Get()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local real dX = x - targetX
        local real dY = y - targetY

        local real angle = Math.AtanByDeltas(dY, dX) + this.angleAdd
        local real dist = target.CollisionSize.Get(true) * 6//Math.Max(Math.DistanceByDeltas(dX, dY) + this.distAdd, target.CollisionSize.Get(true) * 8)

        set targetX = targetX + dist * Math.Cos(angle)
        set targetY = targetY + dist * Math.Sin(angle)

        set dX = targetX - x
        set dY = targetY - y

        set angle = Math.AtanByDeltas(dY, dX)
        set dist = Math.DistanceByDeltas(dX, dY)

        if (dist > this.length) then
            set dist = this.length
        endif

        set x = x + dist * Math.Cos(angle)
        set y = y + dist * Math.Sin(angle)

        call dummyUnit.Facing.Set(angle + Math.QUARTER_ANGLE)
        call dummyUnit.Position.SetXY(x, y)
    endmethod

    timerMethod Weaken
        local thistype this = Timer.GetExpired().GetData()

        local UnitModSet armorMod = this.armorMod
        local integer level = this.level
        local integer powerLevel = this.powerLevel - 1
        local Unit target = this

        set this.powerLevel = powerLevel

        call target.ModSets.Remove(armorMod)

        call armorMod.RealMods.ResetVal(UNIT.Armor.Bonus.STATE, thistype.ARMOR_INC[level] * (powerLevel / thistype.POWER_LEVELS))

        call target.ModSets.Add(armorMod)

		call this.DealDamage()
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local UnitModSet armorMod = this.armorMod
        local DummyUnit dummyUnit = this.dummyUnit
        local Timer updateTimer = this.updateTimer
        local Timer weakenTimer = this.weakenTimer

        call dummyUnit.Destroy()
        call updateTimer.Destroy()
        call weakenTimer.Destroy()

        call target.ModSets.Remove(armorMod)

        call armorMod.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()
        local real z = caster.Position.Z.Get() + target.Impact.Z.Get(true)

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local real dX = targetX - x
        local real dY = targetY - y

        local real angle = Math.AtanByDeltas(dY, dX)

		local thistype this = target

        local UnitModSet armorMod = UnitModSet.Create()
        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x, y, z, angle)
        local Timer updateTimer = Timer.Create()
        local Timer weakenTimer = Timer.Create()

        set this.angle = angle
        set this.angleAdd = Math.FULL_ANGLE / thistype.DURATION_FOR_FULL_ANGLE * thistype.UPDATE_TIME
        set this.armorMod = armorMod
        set this.damagePerInterval = thistype.DAMAGE[level] + thistype.DAMAGE_PER_FOCUS[level] * caster.Agility.Get()
        set this.distAdd = thistype.DIST_ADD_PER_SECOND * thistype.UPDATE_TIME
        set this.dummyUnit = dummyUnit
        set this.length = thistype.SPEED[level] * thistype.UPDATE_TIME
        set this.level = level
        set this.powerLevel = thistype.POWER_LEVELS
        set this.updateTimer = updateTimer
        set this.weakenTimer = weakenTimer
        call updateTimer.SetData(this)
        call weakenTimer.SetData(this)

        call dummyUnit.Scale.Set(1.5)
        call dummyUnit.Scale.Timed.Add(-1, thistype.DURATION[level])

        call armorMod.RealMods.Add(UNIT.Armor.Bonus.STATE, thistype.ARMOR_INC[level])

        call target.ModSets.Add(armorMod)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        call weakenTimer.Start(thistype.DURATION[level] / thistype.POWER_LEVELS, true, function thistype.Weaken)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call target.Buffs.Remove(thistype.DUMMY_BUFF)

        call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, caster, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Artifacts
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct