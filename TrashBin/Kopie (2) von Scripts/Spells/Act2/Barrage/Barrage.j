//! runtextmacro BaseStruct("Barrage", "BARRAGE")
    static real DAMAGE_PER_INTERVAL
    static real DAMAGE_PER_SECOND
    static Buff DUMMY_BUFF
    static Group ENUM_GROUP
    static real INTERVAL
    static real OFFSET
    static BoolExpr TARGET_FILTER

    static real COLOR_FADE_DURATION
    static real RED_INCREMENT
    static real GREEN_INCREMENT
    static real BLUE_INCREMENT
    static real ALPHA_INCREMENT

    static Spell THIS_SPELL

    //! import "Spells\Act2\Barrage\obj.j"

    real areaRange
    Timer intervalTimer

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()

        call target.VertexColor.Timed.Subtract(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT, thistype.COLOR_FADE_DURATION)
    endmethod

    static method Event_EndCast takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        if (Difficulty.SELECTED < Difficulty.HARD) then
            if (target.Classes.Contains(UnitClass.STRUCTURE)) then
                return false
            endif
        endif

        return true
    endmethod

    static method Interval takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real angle = caster.Facing.Get()

        call caster.Animation.Set(UNIT.Animation.ATTACK)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get() + thistype.OFFSET * Math.Cos(angle), caster.Position.Y.Get() + thistype.OFFSET * Math.Sin(angle), this.areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, thistype.DAMAGE_PER_INTERVAL, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.intervalTimer = intervalTimer
        call intervalTimer.SetData(this)

        call target.VertexColor.Timed.Add(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT, thistype.COLOR_FADE_DURATION)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        call caster.Position.SetXY(SPOT.Event.GetTargetX(), SPOT.Event.GetTargetY())

        call caster.Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DAMAGE_PER_INTERVAL = thistype.DAMAGE_PER_SECOND * thistype.INTERVAL
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
    endmethod
endstruct