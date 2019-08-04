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
    UnitList targetGroup
    integer targetsAmount

    method Ending takes nothing returns nothing
        call this.deallocate()
        call this.targetGroup.Destroy()
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

        if UnitList.TEMP.Contains(target) then
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
            local Sound impactSound = Sound.Create(thistype.IMPACT_SOUND_PATH, false, true, true, 10, 10, SoundEax.SPELL)

            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call impactSound.SetPositionAndPlay(target.Position.X.Get(), target.Position.Y.Get(), target.Position.Z.Get())
            call impactSound.Destroy(true)

            set User.TEMP = caster.Owner.Get()

            if thistype.Conditions(target) then
                local real damage = this.damage

                set this.damage = damage * (1. - this.damageReductionFactor)

                if (targetsAmount <= this.stunTargetsAmountMax) then
                    call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, this.level, this.stunDuration)
                endif

                call caster.DamageUnitBySpell(target, damage, true, false)
            endif
        endif

        if (targetsAmount == maxTargetsAmount) then
            call this.Ending()
        else
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set UnitList.TEMP = targetGroup
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, this.areaRange, thistype.TARGET_FILTER)

            local Unit newTarget = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            if (newTarget == NULL) then
                call this.Ending()
            else
                set this.targetsAmount = targetsAmount + 1

                call this.StartMissile(thistype.BOLT_SECONDARY, target, newTarget, targetGroup)
            endif
        endif

        call dummyMissile.Destroy()
    endmethod

    eventMethod Event_Damage
        local Unit caster = params.Unit.GetDamager()
        local Unit target = params.Unit.GetTrigger()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

        local thistype this = thistype.allocate()

		local Group targetGroup = Group.Create()

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

        call this.StartMissile(thistype.BOLT_PRIMARY, caster, target, targetGroup)
    endmethod

    eventMethod Event_BuffLose
        call params.Unit.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        call params.Unit.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Misc
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions_Group)

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct