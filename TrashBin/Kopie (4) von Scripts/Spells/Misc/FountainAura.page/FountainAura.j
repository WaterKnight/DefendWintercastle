//! runtextmacro Folder("FountainAura")
    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        real lifeRegenerationAdd
        FountainAura parent

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            call target.Event.Remove(DEATH_EVENT)
        endmethod

        method Ending takes FountainAura parent, Unit target, Group targetGroup returns nothing
            local real lifeRegenerationAdd = this.lifeRegenerationAdd

            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Buffs.Remove(DUMMY_BUFF)
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            call target.LifeRegeneration.Relative.Subtract(lifeRegenerationAdd)
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local FountainAura parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local FountainAura parent
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
        endmethod

        method Start takes integer level, Unit target, Group targetGroup returns nothing
            local real lifeRegenerationAdd = thistype.LIFE_REGEN_REL_INC
            local FountainAura parent = this

            set this = thistype.allocate()
            set this.lifeRegenerationAdd = lifeRegenerationAdd
            set this.parent = parent
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Buffs.Add(DUMMY_BUFF, level)
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            call target.LifeRegeneration.Relative.Add(lifeRegenerationAdd)
            call targetGroup.AddUnit(target)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FountainAura", "FOUNTAIN_AURA")
    static Group ENUM_GROUP
    static Group ENUM_GROUP2
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "64")

    real areaRange
    integer level
    Group targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("FountainAura", "Target")

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

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (filterUnit.Life.Get() >= Real.ToInt(filterUnit.MaxLife.GetAll())) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local Group targetGroup = this.targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), this.areaRange, thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(caster)

        set target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if (thistype.ENUM_GROUP.ContainsUnit(target)) then
                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                    call targetGroup.RemoveUnit(target)
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
            set level = this.level

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

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ENUM_GROUP2 = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        call thistype(NULL).Target.Init()
    endmethod
endstruct