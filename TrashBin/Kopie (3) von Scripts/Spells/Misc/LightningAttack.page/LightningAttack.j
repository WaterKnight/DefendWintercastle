//! runtextmacro BaseStruct("LightningAttack", "LIGHTNING_ATTACK")
    static Event DAMAGE_EVENT
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    real damage
    real damageReductionFactor
    Missile dummyMissile
    integer level
    integer maxTargetsAmount
    real stunDuration
    integer stunTargetsAmountMax
    Unit target
    Group targetGroup
    integer targetsAmount

    method Ending takes Group targetGroup returns nothing
        call this.deallocate()
        call targetGroup.Destroy()
    endmethod

    static method Conditions takes Unit target returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Conditions_Group takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (Group.TEMP.ContainsUnit(target)) then
            return false
        endif
        if (thistype.Conditions(target) == false) then
            return false
        endif

        return true
    endmethod

    method StartMissile takes string effectLightningPath, Unit oldTarget, Unit target, Group targetGroup returns nothing
        local Missile dummyMissile = Missile.Create()
        local Lightning effectLightning = Lightning.Create(effectLightningPath)

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

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Impact takes nothing returns nothing
        local real damage
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local Unit newTarget
        local real targetX
        local real targetY

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
                set damage = this.damage

                set this.damage = damage * (1. - this.damageReductionFactor)

                if (targetsAmount <= this.stunTargetsAmountMax) then
                    call target.Stun.AddTimed(this.stunDuration, UNIT.Stun.NORMAL_BUFF)
                endif

                call caster.DamageUnitBySpell(target, damage, true, false)
            endif
        endif

        if (targetsAmount == maxTargetsAmount) then
            call this.Ending(targetGroup)
        else
            set targetX = target.Position.X.Get()
            set targetY = target.Position.Y.Get()

            set Group.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

            set newTarget = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            if (newTarget == NULL) then
                call this.Ending(targetGroup)
            else
                set this.targetsAmount = targetsAmount + 1

                call this.StartMissile(thistype.EFFECT_LIGHTNING2_PATH, target, newTarget, targetGroup)
            endif
        endif

        call dummyMissile.Destroy()
    endmethod

    static method Event_Damage takes nothing returns nothing
        local Unit caster = UNIT.Event.GetDamager()
        local Unit target = UNIT.Event.GetTrigger()
        local Group targetGroup = Group.Create()
        local thistype this = thistype.allocate()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.damageReductionFactor = thistype.DAMAGE_REDUCTION_FACTOR[level]
        set this.level = level
        set this.maxTargetsAmount = thistype.TARGETS_AMOUNT[level]
        set this.stunDuration = thistype.STUN_DURATION[level]
        set this.stunTargetsAmountMax = thistype.STUN_TARGETS_AMOUNT[level]
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1

        call this.StartMissile(thistype.EFFECT_LIGHTNING_PATH, caster, target, targetGroup)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions_Group)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct