//! runtextmacro Folder("InnerForce")
    //! runtextmacro Struct("Crit")
        eventMethod Event_Unlearn
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_Learn
            call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            call InnerForce.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call InnerForce.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call InnerForce.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("InnerForce", "INNER_FORCE")
    static Group ENUM_GROUP
    static BoolExpr HEAL_TARGET_FILTER
    static BoolExpr TARGET_FILTER

	boolean destroyed
	integer refs

    real areaRange
    Unit caster
    real damage
    real heal
    Timer intervalTimer
    integer level
    real sourceX
    real sourceY
    SpellInstance whichInstance

	//! runtextmacro LinkToStruct("InnerForce", "Crit")

	method CheckForDestroy takes nothing returns nothing
		if not this.destroyed then
			return
		endif

		if (this.refs > 0) then
			return
		endif

		call this.deallocate()
	endmethod

    timerMethod EndingByTimer
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer
        local SpellInstance whichInstance = this.whichInstance

        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call whichInstance.Destroy()

		set this.destroyed = true

		call this.CheckForDestroy()
    endmethod

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
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    condMethod HealConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

	method DoExplosion takes nothing returns nothing
		local Unit caster = this.caster

		local real areaRange = caster.CollisionSize.Get(true) + this.areaRange
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

		call caster.Effects.Create(thistype.CASTER_EFFECT2_PATH, thistype.CASTER_EFFECT2_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

		set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, areaRange, thistype.HEAL_TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real heal = this.heal

            loop
                call caster.HealBySpell(target, heal)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

		set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage

            loop
            	call target.Position.Timed.Accelerated.AddKnockback(thistype.KNOCKBACK_SPEED, thistype.KNOCKBACK_ACCELERATION, Math.AtanByDeltas(target.Position.Y.Get() - casterY, target.Position.X.Get() - casterX), thistype.KNOCKBACK_DURATION)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
	endmethod

    method Delay takes nothing returns nothing
        call this.DoExplosion()

		set this.refs = this.refs - 1

		call this.CheckForDestroy()
    endmethod

    timerMethod DelayByTimer
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

		call this.DoExplosion()
    endmethod

	method Interval takes nothing returns nothing
		call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

		local Timer delayTimer = Timer.Create()

		set this.refs = this.refs + 1
		call delayTimer.SetData(this)

		call delayTimer.Start(thistype.DELAY, false, function thistype.DelayByTimer)
	endmethod

    timerMethod IntervalByTimer
        call thistype(Timer.GetExpired().GetData()).Interval()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local thistype this = thistype.allocate()

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

		set this.destroyed = false
		set this.refs = 0

        set this.areaRange = areaRange
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.heal = thistype.HEAL[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.whichInstance = whichInstance
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

		call intervalTimer.Start(thistype.INTERVAL, true, function thistype.IntervalByTimer)

        call durationTimer.Start((thistype.WAVES_AMOUNT - 1) * thistype.INTERVAL, false, function thistype.EndingByTimer)

		call this.Interval()
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.HEAL_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.HealConditions)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

		call thistype(NULL).Crit.Init()
    endmethod
endstruct