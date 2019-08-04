//! runtextmacro BaseStruct("EventPair", "EVENT_PAIR")
    //! runtextmacro GetKey("PARTNER_KEY")

    Event negativeEvent
    Event positiveEvent

    //! runtextmacro CreateAnyState("startConditions", "StartConditions", "BoolExpr")

    method GetNegativeEvent takes nothing returns Event
        return this.negativeEvent
    endmethod

    method GetPositiveEvent takes nothing returns Event
        return this.positiveEvent
    endmethod

    static method GetPartnerEvent takes Event source returns Event
        return source.Data.Integer.Get(PARTNER_KEY)
    endmethod

    method SetNegativeEvent takes Event value returns nothing
        local Event positiveEvent = this.GetPositiveEvent()

        set this.negativeEvent = value
        if (positiveEvent != NULL) then
            call positiveEvent.Data.Integer.Set(PARTNER_KEY, value)
            call value.Data.Integer.Set(PARTNER_KEY, positiveEvent)
        endif
    endmethod

    method SetPositiveEvent takes Event value returns nothing
        local Event negativeEvent = this.GetNegativeEvent()

        set this.positiveEvent = value
        if (negativeEvent != NULL) then
            call negativeEvent.Data.Integer.Set(PARTNER_KEY, value)
            call value.Data.Integer.Set(PARTNER_KEY, negativeEvent)
        endif
    endmethod

    static method Create takes Event negativeEvent, Event positiveEvent, BoolExpr startConditions returns thistype
        local thistype this = thistype.allocate()

        set this.negativeEvent = NULL
        set this.positiveEvent = NULL

        call this.SetNegativeEvent(negativeEvent)
        call this.SetPositiveEvent(positiveEvent)
        call this.SetStartConditions(startConditions)

        return this
    endmethod
endstruct

//! runtextmacro Folder("EventCombination")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("EventCombination", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("EventCombination", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("EventCombination", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("EventCombination")
    endstruct

    //! runtextmacro Struct("RemainingEventsAmount")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        method Get takes integer subjectId returns integer
            return Memory.IntegerKeys.GetInteger(subjectId, KEY_ARRAY_DETAIL + this)
        endmethod

        method Event_SubjectRemove takes integer subjectId returns nothing
            call Memory.IntegerKeys.RemoveInteger(subjectId, KEY_ARRAY_DETAIL + this)
        endmethod

        method Set takes integer subjectId, integer value returns nothing
            call Memory.IntegerKeys.SetInteger(subjectId, KEY_ARRAY_DETAIL + this, value)
        endmethod

        method Subtract takes integer subjectId returns boolean
            local integer value = this.Get(subjectId) - 1

            call this.Set(subjectId, value)

            return (value == 0)
        endmethod

        method Add takes integer subjectId returns boolean
            local integer value = this.Get(subjectId) + 1

            call this.Set(subjectId, value)

            return (value == 1)
        endmethod
    endstruct

    //! runtextmacro Struct("Events")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        static method GetParent takes Event whichEvent returns EventCombination
            return whichEvent.Data.Integer.Get(KEY)
        endmethod

        method Count takes nothing returns integer
            return EventCombination(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Event
            return EventCombination(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Remove takes Event whichEvent returns nothing
            call EventCombination(this).Data.Integer.Table.Remove(KEY_ARRAY, whichEvent)
            call whichEvent.Data.Integer.Remove(KEY)
        endmethod

        method Event_Destroy takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Remove(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_PairAdd takes EventPair value returns nothing
            call value.GetNegativeEvent().Data.Integer.Set(KEY, this)
            call value.GetPositiveEvent().Data.Integer.Set(KEY, this)
        endmethod

        static method Event_Passive takes nothing returns nothing
            local Event whichEvent = Event.GetTrigger()

            local EventCombination parent = thistype.GetParent(whichEvent)

            if (parent.RemainingEventsAmount.Get(Event.GetSubjectId()) == 0) then
                call parent.Run(whichEvent)
            endif
        endmethod

        method Create takes EventType whichType, EventPriority priority, BoolExpr whichConditions returns Event
            local Event result = Event.Create(whichType, priority, function thistype.Event_Passive)

            call result.Data.Integer.Set(KEY, this)
            call EventCombination(this).Data.Integer.Table.Add(KEY_ARRAY, result)

            call result.SetConditions(whichConditions)

            return result
        endmethod
    endstruct

    //! runtextmacro Struct("Subjects")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return EventCombination(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns integer
            return EventCombination(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Remove takes integer subjectId returns nothing
            local integer iteration = EventCombination(this).Pairs.Count()
            local EventPair whichPair

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set whichPair = EventCombination(this).Pairs.Get(iteration)

                call whichPair.GetNegativeEvent().Data.Boolean.Remove(subjectId)
                call whichPair.GetPositiveEvent().Data.Boolean.Remove(subjectId)

                set iteration = iteration - 1
            endloop
            call EventCombination(this).Data.Integer.Table.Remove(KEY_ARRAY, subjectId)

            if (EventCombination(this).RemainingEventsAmount.Get(subjectId) == 0) then
                call EventCombination(this).Periodic.Pause(subjectId)
            endif

            call EventCombination(this).RemainingEventsAmount.Event_SubjectRemove(subjectId)
        endmethod

        method Event_Destroy takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Remove(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Add takes integer subjectId returns nothing
            local integer count = 0
            local integer iteration = EventCombination(this).Pairs.Count()
            local boolean startActive
            local EventPair whichPair

            //call EventCombination(this).RemainingEventsAmount.Set(subjectId, 0)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set whichPair = EventCombination(this).Pairs.Get(iteration)

                call Event.SetSubjectId(subjectId)
                call EventCombination.SetTrigger(this)

                set startActive = whichPair.GetStartConditions().Run()

                call EventCombination(this).Pairs.EnableEvent(whichPair.GetNegativeEvent(), subjectId, startActive)
                call EventCombination(this).Pairs.EnableEvent(whichPair.GetPositiveEvent(), subjectId, startActive == false)

                if (startActive == false) then
                    set count = count + 1
                endif

                set iteration = iteration - 1
            endloop
            call EventCombination(this).Data.Integer.Table.Add(KEY_ARRAY, subjectId)

            if (count == 0) then
                call EventCombination(this).Periodic.Start(subjectId)
            endif
            call EventCombination(this).RemainingEventsAmount.Set(subjectId, count)
        endmethod
    endstruct

    //! runtextmacro Folder("Periodic")
        //! runtextmacro Struct("SubjectsA")
            //! runtextmacro GetKeyArray("KEY_ARRAY")

            static method Count takes Timer intervalTimer returns integer
                return intervalTimer.Data.Integer.Table.Count(KEY_ARRAY)
            endmethod

            static method Get takes Timer intervalTimer, integer index returns integer
                return intervalTimer.Data.Integer.Table.Get(KEY_ARRAY, index)
            endmethod

            method Remove takes Timer intervalTimer, integer value returns boolean
                return intervalTimer.Data.Integer.Table.Remove(KEY_ARRAY, value)
            endmethod

            method Add takes Timer intervalTimer, integer value returns boolean
                return intervalTimer.Data.Integer.Table.Add(KEY_ARRAY, value)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Periodic")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Periodic", "SubjectsA")

        method Count takes nothing returns integer
            return EventCombination(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns TriggerTimer
            return EventCombination(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Event_Destroy takes nothing returns nothing
            local TriggerTimer intervalTimer
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set intervalTimer = this.Get(iteration)

                call intervalTimer.Destroy()
                call EventCombination(this).Data.Integer.Table.Remove(KEY_ARRAY, intervalTimer)

                set iteration = iteration - 1
            endloop
        endmethod

        method Pause takes integer subjectId returns nothing
            local TriggerTimer intervalTimer
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set intervalTimer = this.Get(iteration)

                if (thistype(NULL).SubjectsA.Remove(intervalTimer, subjectId)) then
                    call intervalTimer.Pause()
                endif

                set iteration = iteration - 1
            endloop
        endmethod

        method Start takes integer subjectId returns nothing
            local TriggerTimer intervalTimer
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set intervalTimer = this.Get(iteration)

                if (thistype(NULL).SubjectsA.Add(intervalTimer, subjectId)) then
                    call intervalTimer.Resume()
                endif

                set iteration = iteration - 1
            endloop
        endmethod

        static method Interval takes nothing returns nothing
            local TriggerTimer intervalTimer = TriggerTimer.GetExpired()

            local integer iteration = thistype(NULL).SubjectsA.Count(intervalTimer)
            local thistype this = intervalTimer.GetData()

            loop
                call Event.SetSubjectId(thistype(NULL).SubjectsA.Get(intervalTimer, iteration))

                call EventCombination(this).Run(NULL)

                set iteration = iteration - 1

                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Add takes real interval returns nothing
            local TriggerTimer intervalTimer = TriggerTimer.Create()
            local integer subjectId

            local integer iteration = thistype(NULL).SubjectsA.Count(intervalTimer)

            call intervalTimer.AddTrigger(Trigger.CreateFromCode(function thistype.Interval))
            call intervalTimer.SetData(this)
            call intervalTimer.SetPeriodic(true)
            call intervalTimer.SetTimeout(interval)
            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set subjectId = thistype(NULL).SubjectsA.Get(intervalTimer, iteration)

                if (EventCombination(this).RemainingEventsAmount.Get(subjectId) > 0) then
                    if (thistype(NULL).SubjectsA.Add(intervalTimer, subjectId)) then
                        call intervalTimer.Start()
                    endif
                endif

                set iteration = iteration - 1
            endloop
            call EventCombination(this).Data.Integer.Table.Add(KEY_ARRAY, intervalTimer)
        endmethod
    endstruct

    //! runtextmacro Struct("Pairs")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return EventCombination(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns EventPair
            return EventCombination(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        static method EnableEvent takes Event whichEvent, integer subjectId, boolean flag returns nothing
            call whichEvent.Data.Boolean.Set(subjectId, HASH_TABLE.Boolean.DEFAULT_VALUE == flag)
        endmethod

        static method ToggleLockerEventsActivated takes Event whichEvent, integer subjectId returns boolean
            if (whichEvent.Data.Boolean.Get(subjectId) == HASH_TABLE.Boolean.DEFAULT_VALUE) then
                call thistype.EnableEvent(whichEvent, subjectId, false)
                call thistype.EnableEvent(EventPair.GetPartnerEvent(whichEvent), subjectId, true)

                return true
            endif

            return false
        endmethod

        static method Event_Negative takes nothing returns nothing
            local integer subjectId = Event.GetSubjectId()
            local Event whichEvent = Event.GetTrigger()

            local EventCombination parent = EVENT_COMBINATION.Events.GetParent(whichEvent)

            if (thistype.ToggleLockerEventsActivated(whichEvent, subjectId)) then
                if (parent.RemainingEventsAmount.Add(subjectId)) then
                    call parent.Periodic.Pause(subjectId)
                endif
            endif
        endmethod

        static method Event_Positive takes nothing returns nothing
            local integer subjectId = Event.GetSubjectId()
            local Event whichEvent = Event.GetTrigger()

            local EventCombination parent = EVENT_COMBINATION.Events.GetParent(whichEvent)

            if (thistype.ToggleLockerEventsActivated(whichEvent, subjectId)) then
                if (parent.RemainingEventsAmount.Subtract(subjectId)) then
                    call parent.Periodic.Start(subjectId)

                    if (parent.Periodic.Count() > Memory.IntegerKeys.Table.EMPTY) then
                        call parent.Run(whichEvent)
                    endif
                endif
            endif
        endmethod

        method Add takes EventPair whichPair returns nothing
            local TriggerTimer intervalTimer
            local integer iteration = EventCombination(this).Periodic.Count()
            local integer iteration2
            local Event negativeEvent = whichPair.GetNegativeEvent()
            local Event positiveEvent = whichPair.GetPositiveEvent()
            local boolean startActive
            local BoolExpr startConditions = whichPair.GetStartConditions()
            local integer subjectId

            //call this.Data.Integer.Set(COUNTER_KEY, this.Data.Integer.Get(COUNTER_KEY) + 1)
            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set intervalTimer = EventCombination(this).Periodic.Get(iteration)

                set iteration2 = EVENT_COMBINATION.Periodic.SubjectsA.Count(intervalTimer)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    set subjectId = EVENT_COMBINATION.Periodic.SubjectsA.Get(intervalTimer, iteration2)

                    call Event.SetSubjectId(subjectId)
                    call EventCombination.SetTrigger(this)

                    if (startConditions.Run() == false) then
                        call EVENT_COMBINATION.Periodic.SubjectsA.Remove(intervalTimer, subjectId)
                    endif

                    set iteration2 = iteration2 - 1
                endloop
                call intervalTimer.Pause()

                set iteration = iteration - 1
            endloop
            call EventCombination(this).Data.Integer.Table.Add(KEY_ARRAY, whichPair)

            set iteration = EventCombination(this).Subjects.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set subjectId = EventCombination(this).Subjects.Get(iteration)

                call Event.SetSubjectId(subjectId)
                call EventCombination.SetTrigger(this)

                set startActive = startConditions.Run()

                call thistype.EnableEvent(negativeEvent, subjectId, startActive)
                call thistype.EnableEvent(positiveEvent, subjectId, startActive == false)

                set iteration = iteration - 1
            endloop

            call EventCombination(this).Events.Event_PairAdd(whichPair)
        endmethod

        method Create takes EventType positiveType, BoolExpr positiveConditions, EventType negativeType, BoolExpr negativeConditions, BoolExpr startConditions returns EventPair
            local Event negativeEvent = Event.Create(negativeType, EventPriority.COMBINATION, function thistype.Event_Negative)
            local Event positiveEvent = Event.Create(positiveType, EventPriority.COMBINATION, function thistype.Event_Positive)

            local EventPair result = EventPair.Create(negativeEvent, positiveEvent, startConditions)

            call negativeEvent.SetConditions(negativeConditions)
            call positiveEvent.SetConditions(positiveConditions)

            call this.Add(result)

            return result
        endmethod

        method CreateLimit takes EventType whichType, integer value, limitop whichOperator, BoolExpr startConditions returns EventPair
            local Event negativeEvent = Event.Create(whichType, EventPriority.COMBINATION, function thistype.Event_Negative)
            local Event positiveEvent = Event.Create(whichType, EventPriority.COMBINATION, function thistype.Event_Positive)

            local EventPair result = EventPair.Create(negativeEvent, positiveEvent, startConditions)

            call negativeEvent.Limit.Set(value, LimitOp.GetComplement(whichOperator))
            call positiveEvent.Limit.Set(value, whichOperator)

            call this.Add(result)

            return result
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EventCombination", "EVENT_COMBINATION")
    Trigger action

    //! runtextmacro LinkToStruct("EventCombination", "Data")
    //! runtextmacro LinkToStruct("EventCombination", "Events")
    //! runtextmacro LinkToStruct("EventCombination", "Id")
    //! runtextmacro LinkToStruct("EventCombination", "Periodic")
    //! runtextmacro LinkToStruct("EventCombination", "Subjects")
    //! runtextmacro LinkToStruct("EventCombination", "Pairs")
    //! runtextmacro LinkToStruct("EventCombination", "RemainingEventsAmount")

    //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "thistype", "NULL")

    //! runtextmacro CreateAnyState("whichConditions", "Conditions", "BoolExpr")

    method GetAction takes nothing returns Trigger
        return this.action
    endmethod

    method SetAction takes code action returns nothing
        set this.action = Trigger.GetFromCode(action)
    endmethod

    method Destroy takes nothing returns nothing
        call this.Events.Event_Destroy()

        call this.Periodic.Event_Destroy()

        call this.Subjects.Event_Destroy()

        call this.deallocate()
    endmethod

    method Run takes Event fromWhichEvent returns nothing
        if (fromWhichEvent != NULL) then
            call fromWhichEvent.GetResponse().Run()
        endif

        //call Event.SetSubjectId(subjectId)
        call thistype.SetTrigger(this)

        if (this.whichConditions.Run()) then
            call this.action.Run()
        endif
    endmethod

    static method Create takes code action returns thistype
        local thistype this = thistype.allocate()

        set this.whichConditions = NULL
        call this.Id.Event_Create()

        call this.SetAction(action)
        call this.SetConditions(NULL)

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct