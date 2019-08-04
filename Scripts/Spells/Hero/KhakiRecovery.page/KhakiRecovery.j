//! runtextmacro Folder("KhakiRecovery")
    //! runtextmacro Struct("Restoration")
        static Event DEATH_EVENT

        real lifeHeal
        real manaHeal

        eventMethod Event_Death
            local Unit caster = params.Unit.GetKiller()

            local thistype this = caster

            call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

            call caster.HealBySpell(caster, this.lifeHeal)
            call caster.HealManaBySpell(caster, this.manaHeal)
        endmethod

        eventMethod Event_BuffLose
            call params.Unit.GetTrigger().Event.Remove(DEATH_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.lifeHeal = thistype.LIFE_HEAL[level]
            set this.manaHeal = thistype.MANA_HEAL[level]
            call target.Event.Add(DEATH_EVENT)
        endmethod

        eventMethod Event_Unlearn
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_Learn
            call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.KILLER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call KhakiRecovery.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call KhakiRecovery.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call KhakiRecovery.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("KhakiRecovery", "KHAKI_RECOVERY")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    Unit caster
    Timer delayTimer
    real heal
    Unit lastTarget
    integer level
    UnitList targetGroup
    integer targetsAmount
    integer targetsAmountMax

    //! runtextmacro LinkToStruct("KhakiRecovery", "Restoration")

    method Ending takes Timer delayTimer returns nothing
        call this.deallocate()
        call delayTimer.Destroy()
        call this.targetGroup.Destroy()
    endmethod

    method Impact takes Unit caster, integer level, Unit lastTarget, Unit newTarget, integer targetsAmount returns nothing
        local Lightning effectLightning = Lightning.CreatePrimarySecondary((targetsAmount == 0), thistype.BOLT_PRIMARY, thistype.BOLT_SECONDARY)
        local real heal = this.heal * (1. + thistype.HEAL_ADD_FACTOR * (targetsAmount - 1))

        set this.lastTarget = newTarget
        call this.targetGroup.Add(newTarget)

        call newTarget.Effects.Create(thistype.VORTEX_TARGET_EFFECT_PATH, thistype.VORTEX_TARGET_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

		call newTarget.Buffs.Timed.Start(thistype.MOVE_SPEED_BUFF, level, thistype.MOVE_SPEED_BUFF_DURATION[level])

        call caster.HealBySpell(newTarget, heal)

        if (targetsAmount != 0) then
            call effectLightning.SetColor(0, 255, 0, 255)
        endif
        call effectLightning.FromUnitToUnit.Start(lastTarget, newTarget)
        call newTarget.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

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
        if not target.IsAllyOf(User.TEMP) then
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
            call this.Ending(delayTimer)
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
                call this.Ending(delayTimer)
            else
                set this.targetsAmount = targetsAmount

                call this.Impact(caster, this.level, lastTarget, newTarget, targetsAmount - 1)
            endif
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local thistype this = thistype.allocate()

		local Timer delayTimer = Timer.Create()
        local UnitList targetGroup = UnitList.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.heal = thistype.HEAL[level]
        set this.lastTarget = target
        set this.level = level
        set this.targetGroup = targetGroup
        set this.targetsAmount = 1
        set this.targetsAmountMax = thistype.TARGETS_AMOUNT[level]
        call delayTimer.SetData(this)

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call delayTimer.Start(thistype.DELAY, true, function thistype.ChooseNewTargetByTimer)

        call this.Impact(caster, level, caster, target, 0)

        call target.Buffs.Dispel(true, false, true)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Restoration.Init()
    endmethod
endstruct