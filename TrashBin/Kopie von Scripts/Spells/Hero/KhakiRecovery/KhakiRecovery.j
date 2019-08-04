//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("KhakiRecovery", "KHAKI_RECOVERY")
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static real array DAMAGE
    static BoolExpr DAMAGE_TARGET_FILTER
    static real DAMAGE_AREA_WIDTH
    static real DELAY
    static string EFFECT_LIGHTNING_PATH
    static Group ENUM_GROUP
    static string FIRST_LIGHTNING_PATH
    static real array RESTORED_LIFE
    static real RESTORED_LIFE_ADD_FACTOR
    static real array STUN_DURATION
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH
    static BoolExpr TARGET_FILTER
    static integer array TARGETS_AMOUNT

    static Spell THIS_SPELL

    real areaRange
    Unit caster
    Timer delayTimer
    Unit lastTarget
    real restoredLife
    Group targetGroup
    integer targetsAmount
    integer targetsAmountMax

    method Ending takes Timer delayTimer, Group targetGroup returns nothing
        call this.deallocate()
        call delayTimer.Destroy()
        call targetGroup.Destroy()
    endmethod

    method Impact takes Unit caster, Unit lastTarget, Unit newTarget, Group targetGroup, integer targetsAmount returns nothing
        local Lightning effectLightning = Lightning.Create(String.IfElse((targetsAmount == 0), thistype.FIRST_LIGHTNING_PATH, thistype.EFFECT_LIGHTNING_PATH))
        local real restoredLife = this.restoredLife * (1. + thistype.RESTORED_LIFE_ADD_FACTOR * (targetsAmount - 1))

        set this.lastTarget = newTarget
        call targetGroup.AddUnit(newTarget)

        call caster.HealBySpell(newTarget, restoredLife)
        if (targetsAmount != 0) then
            call effectLightning.SetColor(0, 255, 0, 255)
        endif
        call effectLightning.FromUnitToUnit.Start(lastTarget, newTarget)
        call newTarget.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

        call effectLightning.DestroyTimed.Start(0.75)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.NEUTRAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP) == false) then
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

        if (targetsAmount > this.targetsAmountMax) then
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
                call this.Impact(caster, lastTarget, newTarget, targetGroup, targetsAmount - 1)
            endif
        endif
    endmethod

    static method DamageConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method DealDamage takes Unit caster, integer level, Unit target returns nothing
        local real sourceX = caster.Position.X.Get()
        local real sourceY = caster.Position.Y.Get()

        local real dX = target.Position.X.Get() - sourceX
        local real dY = target.Position.Y.Get() - sourceY

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InLine.WithCollision.Do(sourceX, sourceY, Math.DistanceByDeltas(dX, dY), Math.AtanByDeltas(dY, dX), thistype.DAMAGE_AREA_WIDTH, thistype.DAMAGE_AREA_WIDTH, thistype.DAMAGE_TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Stun.AddTimed(thistype.STUN_DURATION[level], UNIT.Stun.NORMAL_BUFF)

                call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
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
        set this.restoredLife = thistype.RESTORED_LIFE[level]
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1
        set this.targetsAmountMax = thistype.TARGETS_AMOUNT[level]
        call delayTimer.SetData(this)

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call thistype.DealDamage(caster, level, target)

        call delayTimer.Start(thistype.DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, caster, target, targetGroup, 0)

        call target.Buffs.Dispel(true, false, true)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_KhakiRecovery.j

        set thistype.DAMAGE_TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct