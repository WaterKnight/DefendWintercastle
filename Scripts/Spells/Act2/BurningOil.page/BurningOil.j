//! runtextmacro BaseStruct("BurningOil", "BURNING_OIL")
    static real DAMAGE_PER_INTERVAL
    static Group ENUM_GROUP
    static Event GROUND_ATTACK_EVENT
    static BoolExpr TARGET_FILTER

    Unit caster
    Timer durationTimer
    Timer intervalTimer
    integer level
    SpotEffect specialEffect
    real targetX
    real targetY

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer
        local SpotEffect specialEffect = this.specialEffect

        call this.deallocate()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call specialEffect.Destroy()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
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

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(this.level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, thistype.DAMAGE_PER_INTERVAL, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_GroundAttack
        local Unit caster = params.Unit.GetTrigger()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

		local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

		local thistype this = thistype.allocate()

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()

        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.specialEffect = Spot.CreateEffect(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW)
        set this.targetX = targetX
        set this.targetY = targetY
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        call target.Event.Remove(GROUND_ATTACK_EVENT)

		call target.Abilities.RemoveBySelf(thistype.MISSILE_GRAPHIC_SPELL_ID)
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()

		call target.Event.Add(GROUND_ATTACK_EVENT)

        call target.Abilities.AddBySelf(thistype.MISSILE_GRAPHIC_SPELL_ID)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Act2
        set thistype.DAMAGE_PER_INTERVAL = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.GROUND_ATTACK_EVENT = Event.Create(UNIT.Attack.Events.Ground.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GroundAttack)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct