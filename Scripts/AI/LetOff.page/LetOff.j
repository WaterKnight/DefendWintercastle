//! runtextmacro BaseStruct("AILetOff", "AI_LET_OFF")
    static Event ACQUIRE_EVENT
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static Unit TARGET
    static Timer UPDATE_TIMER

    static constant real MAX_RANGE_SQUARE = thistype.MAX_RANGE * thistype.MAX_RANGE

    Unit target

    //! runtextmacro CreateList("ACTIVE_LIST")
    //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

    timerMethod Update
        call thistype.FOR_EACH_LIST_Set()

        loop
            local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
            exitwhen (this == NULL)

            local Unit source = this
            local Unit target = this.target

            if (Math.DistanceSquareByDeltas(target.Position.Y.Get() - source.Position.Y.Get(), target.Position.X.Get() - source.Position.X.Get()) > thistype.MAX_RANGE_SQUARE) then
                call source.Buffs.Remove(thistype.DUMMY_BUFF)

                call WAYPOINT.Spawns.Update(source)
            endif
        endloop
    endmethod

    eventMethod Event_TargetBuffLose
        local Unit target = params.Unit.GetTrigger()

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, Memory.IntegerKeys.Table.STARTED)

            exitwhen (this == NULL)

            call Unit(this).Buffs.Remove(thistype.DUMMY_BUFF)
        endloop
    endmethod

    eventMethod Event_TargetBuffGain
    endmethod

    eventMethod Event_BuffLose
        local Unit source = params.Unit.GetTrigger()

        local thistype this = source

        local Unit target = this.target

        if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call target.Buffs.Remove(thistype.TARGET_BUFF)
        endif

        if thistype.ACTIVE_LIST_Remove(this) then
            call thistype.UPDATE_TIMER.Pause()
        endif
    endmethod

    eventMethod Event_BuffGain
        local Unit source = params.Unit.GetTrigger()
        local Unit target = thistype.TARGET

        local thistype this = source

        set this.target = target
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Buffs.Add(thistype.TARGET_BUFF, 1)
        endif

        call source.Order.UnitTarget(Order.ATTACK, target)

        if thistype.ACTIVE_LIST_Add(this) then
            call thistype.UPDATE_TIMER.Start(3., true, function thistype.Update)
        endif
    endmethod

    eventMethod Event_Acquire
        local Unit source = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()

        if not target.Classes.Contains(UnitClass.HERO) then
            return
        endif

        set thistype.TARGET = target

        call source.Buffs.Add(thistype.DUMMY_BUFF, 1)
    endmethod

    eventMethod Event_Spawn
        local Unit source = params.Unit.GetTrigger()

        call source.Event.Add(thistype.ACQUIRE_EVENT)
    endmethod

    initMethod Init of AI_Misc
        set thistype.ACQUIRE_EVENT = Event.Create(UNIT.Attack.Events.ACQUIRE_EVENT_TYPE, EventPriority.AI, function thistype.Event_Acquire)
        set thistype.UPDATE_TIMER = Timer.Create()
        call Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_Spawn).AddToStatics()
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_BuffLose))
        call thistype.TARGET_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_TargetBuffGain))
        call thistype.TARGET_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_TargetBuffLose))
    endmethod
endstruct