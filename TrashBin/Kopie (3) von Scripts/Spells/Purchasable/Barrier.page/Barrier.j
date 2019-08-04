//! runtextmacro Folder("Barrier")
    //! runtextmacro Struct("Knockback")
        static Group ENUM_GROUP
        //! runtextmacro GetKey("KEY")
        static BoolExpr TARGET_FILTER
        static constant real UPDATE_TIME = 0.1

        Group targetGroup
        Timer updateTimer

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local Group targetGroup = this.targetGroup
            local Timer updateTimer = this.updateTimer

            call targetGroup.Destroy()
            call updateTimer.Destroy()
        endmethod

        static method Conditions takes nothing returns boolean
            local Unit filterUnit = UNIT.Event.Native.GetFilter()

            if (Group.TEMP.ContainsUnit(filterUnit)) then
                return false
            endif

            if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
                return false
            endif

            return true
        endmethod

        static method Update takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()
            local Unit victim

            local Unit target = this
            local Group targetGroup = this.targetGroup

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set Group.TEMP = targetGroup

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.AREA_RANGE, thistype.TARGET_FILTER)

            set victim = thistype.ENUM_GROUP.FetchFirst()

            if (victim != NULL) then
                loop
                    call targetGroup.AddUnit(victim)
                    call victim.Position.Timed.Accelerated.AddKnockback(1000., -520., Math.AtanByDeltas(victim.Position.Y.Get() - targetY, victim.Position.X.Get() - targetX), 0.35)

                    set victim = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (victim == NULL)
                endloop
            endif
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local Timer updateTimer = Timer.Create()

            local thistype this = target

            set this.targetGroup = Group.Create()
            set this.updateTimer = updateTimer
            call updateTimer.SetData(this)

            call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endmethod

        static method Start takes Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, Barrier.MOVE_DURATION)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Barrier", "BARRIER")
    //! runtextmacro LinkToStruct("Barrier", "Knockback")

    static method Event_SpellEffect takes nothing returns nothing
        local Unit barrier
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()

        local real angle = caster.Facing.Get()
        local User casterOwner = caster.Owner.Get()
        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real angleX = Math.Cos(angle)
        local real angleY = Math.Sin(angle)
        local real duration = thistype.DURATION[level]
        local integer iteration = thistype.SUMMONS_AMOUNT[level]
        local UnitType summonUnitType = thistype.SUMMON_UNIT_TYPES[level]

        local real targetX = casterX + thistype.CASTER_OFFSET * angleX
        local real targetY = casterY + thistype.CASTER_OFFSET * angleY
        local real window = iteration * thistype.WINDOW_PER_SUMMON

        set angle = angle - window / 2.

        loop
            set barrier = Unit.Create(summonUnitType, casterOwner, targetX, targetY, UNIT.Facing.STANDARD)

            call barrier.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
            call barrier.Classes.Add(UnitClass.STRUCTURE)
            call barrier.Effects.Create(thistype.BARRIER_EFFECT_PATH, thistype.BARRIER_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)
            call barrier.Movement.RemovePermanently()
            call barrier.Pathing.Subtract()
            call barrier.Position.X.Set(targetX)
            call barrier.Position.Y.Set(targetY)

            call barrier.Position.Timed.AddNoCheck(thistype.OFFSET * Math.Cos(angle), thistype.OFFSET * Math.Sin(angle), 0., thistype.MOVE_DURATION)

            call barrier.ApplyTimedLife(duration)

            call thistype(NULL).Knockback.Start(barrier)

            set iteration = iteration - 1
            exitwhen (iteration < 1)

            set angle = angle + thistype.WINDOW_PER_SUMMON
        endloop
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Knockback.Init()
    endmethod
endstruct