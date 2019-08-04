//! runtextmacro Folder("FairysTears")
    //! runtextmacro Struct("Target")
        Unit caster
        real damage
        Timer damageTimer
        integer level

        timerMethod DealDamage
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, thistype.COLD_DURATION[level])

            call this.caster.DamageUnitBySpell(target, this.damage, true, false)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer damageTimer = this.damageTimer

            call damageTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = Unit.TEMP
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer damageTimer = Timer.Create()

            set this.caster = caster
            set this.damage = TEMP_REAL
            set this.damageTimer = damageTimer
            set this.level = level
            call damageTimer.SetData(this)

            call damageTimer.Start(thistype.DAMAGE_DELAY, false, function thistype.DealDamage)
        endmethod

        static method Start takes Unit caster, real damage, integer level, Unit target returns nothing
            set TEMP_REAL = damage
            set Unit.TEMP = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FairysTears", "FAIRYS_TEARS")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    real damage
    DummyUnit dummyUnit
    Timer intervalTimer
    integer level

    //! runtextmacro LinkToStruct("FairysTears", "Target")

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

        if target.Buffs.Contains(thistype(NULL).Target.DUMMY_BUFF) then
            return false
        endif

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        set User.TEMP = target.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

        local Unit target2 = thistype.ENUM_GROUP.GetRandom()

        if (target2 != NULL) then
            call thistype(NULL).Target.Start(target, this.damage, this.level, target2)
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer intervalTimer = this.intervalTimer

        call dummyUnit.Destroy()
        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

		//call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local thistype this = target

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, Spot.GetHeight(targetX, targetY), 0.)
		local Timer intervalTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.damage = thistype(NULL).Target.DAMAGE[level] + target.SpellPower.Get() * thistype(NULL).Target.DAMAGE_SPELL_POWER_MOD_FACTOR
        set this.dummyUnit = dummyUnit
        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call dummyUnit.FollowUnit.Start(target, false, false, 0., 0., 0.)
        call dummyUnit.SetScale(thistype.THIS_SPELL.GetAreaRange(level) * 4 / (4 * 128.))

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    eventMethod Event_EndCast
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct