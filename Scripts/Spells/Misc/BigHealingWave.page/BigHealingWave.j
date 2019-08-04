//! runtextmacro BaseStruct("BigHealingWave", "BIG_HEALING_WAVE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    Timer delayTimer
    Unit lastTarget
    UnitList targetGroup
    integer targetsAmount

    method Ending takes nothing returns nothing
        call this.deallocate()
        call this.delayTimer.Destroy()
        call this.targetGroup.Destroy()
    endmethod

    method Impact takes Unit lastTarget, Unit newTarget returns nothing
        local Lightning effectLightning = Lightning.CreatePrimarySecondary((lastTarget == newTarget), thistype.BOLT, thistype.BOLT_SEC)

        set this.lastTarget = newTarget

        call caster.HealBySpell(newTarget, thistype.RESTORED_LIFE_FACTOR * newTarget.MaxLife.Get())

        call effectLightning.FromUnitToUnit.Start(lastTarget, newTarget)

        call newTarget.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(0.)

        call this.targetGroup.Add(newTarget)

        call effectLightning.DestroyTimed.Start(0.75)
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
        if (target.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    timerMethod ChooseNewTargetByTimer
        local Unit caster
        local Timer delayTimer = Timer.GetExpired()
        local Unit lastTarget
        local real lastTargetX
        local real lastTargetY
        local Unit newTarget

        local thistype this = delayTimer.GetData()

        local UnitList targetGroup = this.targetGroup
        local integer targetsAmount = this.targetsAmount + 1

        if (targetsAmount > thistype.TARGETS_AMOUNT) then
            call this.Ending()
        else
            set caster = this.caster
            set lastTarget = this.lastTarget
            set lastTargetX = lastTarget.Position.X.Get()
            set lastTargetY = lastTarget.Position.Y.Get()

            set UnitList.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(lastTargetX, lastTargetY, this.areaRange, thistype.TARGET_FILTER)

            set newTarget = thistype.ENUM_GROUP.GetNearest(lastTargetX, lastTargetY)

            if (newTarget == NULL) then
                call this.Ending()
            else
                set this.targetsAmount = targetsAmount

                call this.Impact(lastTarget, newTarget)
            endif
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local thistype this = thistype.allocate()

		local Timer delayTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.lastTarget = target
        set this.targetGroup = UnitList.Create()
        set this.targetsAmount = 1
        call delayTimer.SetData(this)

        call delayTimer.Start(thistype.DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, target)
    endmethod

    initMethod Init of Spells_Misc
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct