//! runtextmacro BaseStruct("BigHealingWave", "BIG_HEALING_WAVE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    Timer delayTimer
    Unit lastTarget
    Group targetGroup
    integer targetsAmount

    method Ending takes Timer delayTimer, Group targetGroup returns nothing
        call this.deallocate()
        call delayTimer.Destroy()
        call targetGroup.Destroy()
    endmethod

    method Impact takes Unit lastTarget, Unit newTarget, Group targetGroup returns nothing
        local Lightning effectLightning = Lightning.Create(String.IfElse((lastTarget == newTarget), EFFECT_LIGHTNING_PATH, EFFECT_LIGHTNING2_PATH))

        set this.lastTarget = newTarget
        call caster.HealBySpell(newTarget, thistype.RESTORED_LIFE_FACTOR * newTarget.MaxLife.GetAll())
        call effectLightning.FromUnitToUnit.Start(lastTarget, newTarget)
        call newTarget.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(0.)
        call targetGroup.AddUnit(newTarget)

        call effectLightning.DestroyTimed.Start(0.75)
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
        if (filterUnit.Classes.Contains(UnitClass.NEUTRAL)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method ChooseNewTargetByTimer takes nothing returns nothing
        local Unit caster
        local Timer delayTimer = Timer.GetExpired()
        local Unit lastTarget
        local real lastTargetX
        local real lastTargetY
        local Unit newTarget

        local thistype this = delayTimer.GetData()

        local Group targetGroup = this.targetGroup
        local integer targetsAmount = this.targetsAmount + 1

        if (targetsAmount > thistype.TARGETS_AMOUNT) then
            call this.Ending(delayTimer, targetGroup)
        else
            set caster = this.caster
            set lastTarget = this.lastTarget
            set lastTargetX = lastTarget.Position.X.Get()
            set lastTargetY = lastTarget.Position.Y.Get()

            set Group.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(lastTargetX, lastTargetY, this.areaRange, thistype.TARGET_FILTER)

            set newTarget = thistype.ENUM_GROUP.GetNearest(lastTargetX, lastTargetY)

            if (newTarget == NULL) then
                call this.Ending(delayTimer, targetGroup)
            else
                set this.targetsAmount = targetsAmount
                call this.Impact(lastTarget, newTarget, targetGroup)
            endif
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer delayTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()
        local Group targetGroup = Group.Create()
        local thistype this = thistype.allocate()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.lastTarget = target
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1
        call delayTimer.SetData(this)

        call delayTimer.Start(thistype.DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, target, targetGroup)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct