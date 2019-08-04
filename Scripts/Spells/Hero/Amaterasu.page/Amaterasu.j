//! runtextmacro Folder("Amaterasu")
    //! runtextmacro Struct("Target")
        static method Start takes Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Amaterasu", "AMATERASU")
    static real array DAMAGE
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    real areaRange
    real damage
    Timer intervalTimer
    integer level
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("Amaterasu", "Target")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.MagicImmunity.Try() then
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

        /*if (Math.RandomI(0, 1) == 0) then
            call Spot.CreateRipple(this.targetX, this.targetY, target.CollisionSize.Get(true), this.areaRange + 100., 128., 3.)
            call SPOT.DeformNova.Create(this.targetX, this.targetY, 64., this.areaRange + 100., 200.)
        endif*/

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(this.targetX, this.targetY, this.areaRange, thistype.TARGET_FILTER)

        local Unit target2 = thistype.ENUM_GROUP.FetchFirst()

        if (target2 != NULL) then
            local real damage = this.damage

            loop
                call thistype(NULL).Target.Start(target2)

                if target2.Classes.Contains(UnitClass.GROUND) then
                    call target.DamageUnitBySpell(target2, damage, false, false)
                else
                    call target.DamageUnitBySpell(target2, damage * thistype.DAMAGE_AIR_FACTOR, false, false)
                endif

                set target2 = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target2 == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local thistype this = target

		local Timer intervalTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.damage = thistype.DAMAGE[level]
        set this.intervalTimer = intervalTimer
        set this.targetX = targetX
        set this.targetY = targetY
        call intervalTimer.SetData(this)

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

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.DAMAGE[iteration] = thistype.DAMAGE_ALL[iteration] / Real.ToInt(thistype.THIS_SPELL.GetChannelTime(iteration) / thistype(NULL).Target.DURATION)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

		call thistype(NULL).Target.Init()
    endmethod
endstruct