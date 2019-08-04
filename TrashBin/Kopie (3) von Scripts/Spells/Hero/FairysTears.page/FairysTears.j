//! runtextmacro Folder("FairysTears")
    //! runtextmacro Struct("Target")
        Unit caster
        real damage
        Timer damageTimer
        integer level

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Timer damageTimer = this.damageTimer

            call damageTimer.Destroy()
        endmethod

        static method DealDamage takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Cold.AddTimed(thistype.COLD_DURATION[level])

            call this.caster.DamageUnitBySpell(target, this.damage, true, false)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = Unit.TEMP
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()
            local Timer damageTimer = Timer.Create()

            local thistype this = target

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
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FairysTears", "FAIRYS_TEARS")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dStf", "FairysTears", "DUMMY_UNIT_ID", "Spells\\Starfall\\Area.mdx")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    real damage
    DummyUnit dummyUnit
    Timer intervalTimer
    integer level

    //! runtextmacro LinkToStruct("FairysTears", "Target")

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local DummyUnit dummyUnit = this.dummyUnit
        local Timer intervalTimer = this.intervalTimer

        call dummyUnit.Destroy()
        call intervalTimer.Destroy()
    endmethod

    static method Event_EndCast takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Conditions takes nothing returns boolean
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

        if (target.Buffs.Contains(thistype(NULL).Target.DUMMY_BUFF)) then
            return false
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local Unit target2
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        set User.TEMP = target.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(target.Position.X.Get(), target.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

        set target2 = thistype.ENUM_GROUP.GetRandom()

        if (target2 != NULL) then
            call thistype(NULL).Target.Start(target, this.damage, this.level, target2)
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()
        local thistype this = target

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, Spot.GetHeight(targetX, targetY), 0.)

        //call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.damage = thistype(NULL).Target.DAMAGE[level] + target.SpellPower.GetAll() * thistype(NULL).Target.DAMAGE_SPELL_POWER_MOD_FACTOR
        set this.dummyUnit = dummyUnit
        set this.intervalTimer = intervalTimer
        set this.level = level
        call intervalTimer.SetData(this)

        call dummyUnit.FollowUnit.Start(target, false, false, 0., 0., 0.)
        call dummyUnit.SetScale(thistype.THIS_SPELL.GetAreaRange(level) * 4 / (4 * 128.))

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct