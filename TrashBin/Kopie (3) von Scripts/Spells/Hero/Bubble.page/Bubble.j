//! runtextmacro Folder("Bubble")
    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        Bubble parent

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Event.Remove(DEATH_EVENT)
            call target.Invulnerability.Subtract(UNIT.Invulnerability.NONE_BUFF)
        endmethod

        method Ending takes Bubble parent, Unit target, Group targetGroup returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Buffs.Remove(thistype.DUMMY_BUFF)
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local Bubble parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local Bubble parent
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)
                set parent = this.parent

                call this.Ending(parent, target, parent.targetGroup)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Event.Add(DEATH_EVENT)
            call target.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
        endmethod

        method Start takes integer level, Unit target, Group targetGroup returns nothing
            local Bubble parent = this

            set this = thistype.allocate()

            set this.parent = parent
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Buffs.Add(thistype.DUMMY_BUFF, level)
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            call targetGroup.AddUnit(target)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Bubble", "BUBBLE")
    static Group ENUM_GROUP
    static Group ENUM_GROUP2
    static BoolExpr TARGET_FILTER
    static constant real UPDATE_TIME = 0.75

    real areaRange
    integer level
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("Bubble", "Target")

    method ClearTargetGroup takes Group targetGroup returns nothing
        local Unit target

        loop
            set target = targetGroup.GetFirst()
            exitwhen (target == NULL)

            call this.Target.EndingByParent(target, targetGroup)
        endloop
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.ClearTargetGroup(targetGroup)

        call targetGroup.Destroy()
        call updateTimer.Destroy()
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
        if (target.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local Group targetGroup = this.targetGroup

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(caster)

        set target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if (thistype.ENUM_GROUP.ContainsUnit(target)) then
                    call targetGroup.RemoveUnit(target)

                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                else
                    call this.Target.EndingByParent(target, targetGroup)
                endif

                set target = targetGroup.GetFirst()
                exitwhen (target == NULL)
            endloop

            call targetGroup.AddGroupClear(thistype.ENUM_GROUP2)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call this.Target.Start(level, target, targetGroup)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()
        local Timer updateTimer = Timer.Create()

        local thistype this = target

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.level = level
        set this.targetGroup = Group.Create()
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        call caster.Position.SetXYZ(targetX, targetY, Spot.GetHeight(targetX, targetY))

        call caster.Buffs.Add(thistype.DUMMY_BUFF, level)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ENUM_GROUP2 = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct