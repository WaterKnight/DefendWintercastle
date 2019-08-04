//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("HeatExplosion", "HEAT_EXPLOSION")
    static real ACCELERATION
    static real BUFF_DURATION
    static string CASTER_BUFF_EFFECT_ATTACH_POINT
    static string CASTER_BUFF_EFFECT_PATH
    static string CASTER_EFFECT_ATTACH_POINT
    static string CASTER_EFFECT_PATH
    static string CASTER_EFFECT2_ATTACH_POINT
    static string CASTER_EFFECT2_PATH
    static real array DAMAGE
    static real DELAY
    static Buff DUMMY_BUFF
    static real DURATION
    static Group ENUM_GROUP
    static real INTERVAL
    static real SPEED
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    real areaRange
    Unit caster
    UnitEffect casterEffect
    real damage
    Timer intervalTimer
    integer level
    real sourceX
    real sourceY
    SpellInstance whichInstance

    static method EndingByTimer takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local UnitEffect casterEffect = this.casterEffect
        local Timer intervalTimer = this.intervalTimer
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call casterEffect.Destroy()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
        call whichInstance.Destroy()
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Buffs.Contains(thistype.DUMMY_BUFF)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    method Interval takes nothing returns nothing
        local Unit caster = this.caster
        local integer level
        local Unit target

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, this.areaRange, thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(this.caster)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set level = this.level

            loop
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.BUFF_DURATION)
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                call target.Movement.SubtractTimed(thistype.BUFF_DURATION)

                call target.Position.Timed.Accelerated.AddKnockback(thistype.SPEED, thistype.ACCELERATION, Math.AtanByDeltas(target.Position.Y.Get() - casterY, target.Position.X.Get() - casterX), thistype.BUFF_DURATION)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method IntervalByTimer takes nothing returns nothing
        call thistype(Timer.GetExpired().GetData()).Interval()
    endmethod

    static method Delay takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()
        local Unit target

        local thistype this = durationTimer.GetData()

        local Unit caster = this.caster
        local real damage = this.damage

        call caster.Effects.Create(thistype.CASTER_EFFECT2_PATH, thistype.CASTER_EFFECT2_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        set this.casterEffect = caster.Effects.Create(thistype.CASTER_BUFF_EFFECT_PATH, thistype.CASTER_BUFF_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.IntervalByTimer)

        call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)

        call this.Interval()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()
        local integer level = SPELL.Event.GetLevel()
        local thistype this = thistype.allocate()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.areaRange = areaRange
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.whichInstance = whichInstance
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call durationTimer.Start(thistype.DELAY, false, function thistype.Delay)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_HeatExplosion.j

        set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct