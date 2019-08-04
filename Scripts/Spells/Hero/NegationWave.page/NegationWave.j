//! runtextmacro BaseStruct("NegationWave", "NEGATION_WAVE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    real damage
    Timer delayTimer
    Unit lastTarget
    integer level
    UnitList targetGroup
    integer targetsAmount
    integer targetsAmountMax

    method Ending takes nothing returns nothing
        call this.deallocate()
        call this.delayTimer.Destroy()
        call this.targetGroup.Destroy()
    endmethod

    method Impact takes Unit lastTarget, Unit newTarget, integer targetsAmount returns nothing
        local Lightning effectLightning = Lightning.Create(thistype.BOLT)

        set this.lastTarget = newTarget
        call effectLightning.FromUnitToUnit.Start(lastTarget, newTarget)
        call newTarget.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)
        call this.targetGroup.Add(newTarget)

        call effectLightning.DestroyTimed.Start(0.75)

		local real silenceDuration

		if newTarget.Classes.Contains(UnitClass.HERO) then
			set silenceDuration = thistype.SILENCE_HERO_DURATION[level]
		else
			set silenceDuration = thistype.SILENCE_DURATION[level]
		endif

        call newTarget.Buffs.Timed.Start(thistype.SILENCE_BUFF, this.level, silenceDuration)

        call caster.DamageUnitBySpell(newTarget, damage, true, false)
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

    timerMethod ChooseNewTargetByTimer
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        local UnitList targetGroup = this.targetGroup
        local integer targetsAmount = this.targetsAmount + 1

        if (targetsAmount > this.targetsAmountMax) then
            call this.Ending()
        else
            local Unit caster = this.caster
            local Unit lastTarget = this.lastTarget
            local real lastTargetX = lastTarget.Position.X.Get()
            local real lastTargetY = lastTarget.Position.Y.Get()

            set UnitList.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(lastTargetX, lastTargetY, this.areaRange, thistype.TARGET_FILTER)

            local Unit newTarget = thistype.ENUM_GROUP.GetNearest(lastTargetX, lastTargetY)

            if (newTarget == NULL) then
                call this.Ending()
            else
                set this.targetsAmount = targetsAmount

                call this.Impact(lastTarget, newTarget, targetsAmount - 1)
            endif
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

		call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        local thistype this = thistype.allocate()

        local Timer delayTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.delayTimer = delayTimer
        set this.lastTarget = target
        set this.level = level
        set this.targetGroup = UnitList.Create()
        set this.targetsAmount = 1
        set this.targetsAmountMax = thistype.TARGETS_AMOUNT[level]
        call delayTimer.SetData(this)

        call delayTimer.Start(thistype.DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, target, 0)

        call caster.Buffs.Steal(target, false, true, level)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Silence.NORMAL_BUFF.Variants.Add(thistype.SILENCE_BUFF)
    endmethod
endstruct