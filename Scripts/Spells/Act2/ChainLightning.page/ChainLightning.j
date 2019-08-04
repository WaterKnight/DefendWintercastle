//! runtextmacro BaseStruct("ChainLightning", "CHAIN_LIGHTNING")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    real damage
    real damageReductionFactor
    Missile dummyMissile
    integer level
    integer maxTargetsAmount
    Unit target
    Group targetGroup
    integer targetsAmount

    method Ending takes Group targetGroup returns nothing
        call this.deallocate()
        call targetGroup.Destroy()
    endmethod

    static method Conditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
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

    condMethod Conditions_Group
        local Unit target = UNIT.Event.Native.GetFilter()

        if Group.TEMP.ContainsUnit(target) then
            return false
        endif
        if not thistype.Conditions(target) then
            return false
        endif

        return true
    endmethod

    method StartMissile takes LightningType boltType, Unit oldTarget, Unit target, Group targetGroup returns nothing
        local Missile dummyMissile = Missile.Create()
        local Lightning effectLightning = Lightning.Create(boltType)

        set this.dummyMissile = dummyMissile
        set this.target = target
        call effectLightning.FromUnitToUnit.Start(oldTarget, target)
        call targetGroup.AddUnit(target)

        call effectLightning.DestroyTimed.Start(0.75)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(Math.Max(Math.DistanceByDeltas(target.Position.X.Get() - oldTarget.Position.X.Get(), target.Position.Y.Get() - oldTarget.Position.Y.Get()) / 0.25, 700.))
        call dummyMissile.Position.SetFromUnit(oldTarget)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer maxTargetsAmount = this.maxTargetsAmount
        local integer targetsAmount = this.targetsAmount
        local Unit target = this.target
        local Group targetGroup = this.targetGroup

        if (target != NULL) then
            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            set User.TEMP = caster.Owner.Get()

            if (thistype.Conditions(target)) then
                local real damage = this.damage

                set this.damage = damage * (1. - this.damageReductionFactor)

                call caster.DamageUnitBySpell(target, damage, true, false)
            endif
        endif

        if (targetsAmount == maxTargetsAmount) then
            call this.Ending(targetGroup)
        else
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set Group.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

            local Unit newTarget = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            if (newTarget == NULL) then
                call this.Ending(targetGroup)
            else
                set this.targetsAmount = targetsAmount + 1

                call this.StartMissile(thistype.BOLT_SECONDARY, target, newTarget, targetGroup)
            endif
        endif

        call dummyMissile.Destroy()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local thistype this = thistype.allocate()

		local Group targetGroup = Group.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE
        set this.damageReductionFactor = thistype.DAMAGE_REDUCTION_FACTOR
        set this.level = level
        set this.maxTargetsAmount = thistype.TARGETS_AMOUNT
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1

        call this.StartMissile(thistype.BOLT_PRIMARY, caster, target, targetGroup)
    endmethod

    initMethod Init of Spells_Act2
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions_Group)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct