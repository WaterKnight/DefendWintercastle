//! runtextmacro BaseStruct("TimerDialog", "TIMER_DIALOG")
    timerdialog self

    method Destroy takes nothing returns nothing
        local timerdialog self = this.self

        call this.deallocate()
        call DestroyTimerDialog(self)

        set self = null
    endmethod

    method Hide takes nothing returns nothing
        call TimerDialogDisplay(this.self, false)
    endmethod

    method Show takes nothing returns nothing
        call TimerDialogDisplay(this.self, true)
    endmethod

    method SetTitle takes string title returns nothing
        call TimerDialogSetTitle(this.self, title)
    endmethod

    static method CreateFromTimer takes Timer source returns thistype
        local thistype this = thistype.allocate()

        set this.self = CreateTimerDialog(source.self)

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("TriggerTimer")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("TriggerTimer", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("TriggerTimer", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("TriggerTimer")
    endstruct
endscope

//! runtextmacro BaseStruct("TriggerTimer", "TRIGGER_TIMER")
    //! runtextmacro GetKey("KEY")

    boolean periodic
    timer self
    real timeout

    //! runtextmacro LinkToStruct("TriggerTimer", "Data")
    //! runtextmacro LinkToStruct("TriggerTimer", "Id")

    //! runtextmacro CreateAnyState("data", "Data", "integer")

    static method GetExpired takes nothing returns TriggerTimer
        return Memory.IntegerKeys.GetIntegerByHandle(GetExpiredTimer(), KEY)
    endmethod

    method Pause takes nothing returns nothing
        call PauseTimer(this.self)
    endmethod

    method Destroy takes nothing returns nothing
        local timer self = this.self

        call this.deallocate()
        call this.Pause()

        call DestroyTimer(self)

        set self = null
    endmethod

    method SetPeriodic takes boolean value returns nothing
        set this.periodic = value
    endmethod

    method SetTimeout takes real value returns nothing
        set this.timeout = value
    endmethod

    method Start takes nothing returns nothing
        call TimerStart(this.self, this.timeout, this.periodic, null)
    endmethod

    method Resume takes nothing returns nothing
        call this.Start()
    endmethod

    method AddTrigger takes Trigger whichTrigger returns nothing
        call TriggerRegisterTimerExpireEvent(whichTrigger.self, this.self)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

		local timer self = CreateTimer()

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        set self = null
        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Timer")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Timer", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Timer", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Timer")
    endstruct
endscope

//! runtextmacro BaseStruct("Timer", "TIMER")
    static key KEY
    private static integer QUEUE_SIZE = ARRAY_EMPTY
    private static thistype array QUEUED

    //! runtextmacro CreateList("RUNNING_LIST")
    //! runtextmacro CreateForEachList("FOR_EACH_RUNNING_LIST", "RUNNING_LIST")

    timer self

    //! runtextmacro LinkToStruct("Timer", "Data")
    //! runtextmacro LinkToStruct("Timer", "Id")

    //! runtextmacro CreateAnyState("action", "Action", "Trigger")
    //! runtextmacro CreateAnyState("actionFunc", "ActionFunc", "integer")
    //! runtextmacro CreateAnyState("data", "Data", "integer")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyState("timeout", "Timeout", "real")
    //! runtextmacro CreateAnyState("timeoutMax", "TimeoutMax", "real")
    //! runtextmacro CreateAnyState("timeoutMin", "TimeoutMin", "real")

    static method GetFromSelf takes timer self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetExpired takes nothing returns thistype
        //return thistype.TEMP
        return thistype.GetFromSelf(GetExpiredTimer())
    endmethod

    method GetSelf takes nothing returns timer
        return this.self
    endmethod

    method GetElapsed takes nothing returns real
        return TimerGetElapsed(this.self)
    endmethod

    method GetRemaining takes nothing returns real
        return TimerGetRemaining(this.self)
    endmethod

    method Pause takes nothing returns nothing
        call PauseTimer(this.self)

        call thistype.RUNNING_LIST_Remove(this)
    endmethod

    method Abort takes nothing returns nothing
        call this.Pause()
        call this.SetTimeout(0.)
    endmethod
    /*method Pause takes nothing returns nothing
        if not this.isRunning then
            return
        endif

        set this.isRunning = false
        set this.remainingTicks = 1
        if (this == thistype.FIRST_TO_RUN) then
            set thistype.FIRST_TO_RUN = this.next
        else
            if (this.next == NULL) then
                set this.prev.next = NULL
            else
                set this.next.prev = this.prev
                set this.prev.next = this.next
            endif
        endif
    endmethod*/

    method Resume takes nothing returns nothing
        call ResumeTimer(this.self)
    endmethod

    method Destroy takes nothing returns nothing
        set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE + 1
        set thistype.QUEUED[thistype.QUEUE_SIZE] = this
        call this.Pause()
    endmethod

    static method RequestRunningList takes nothing returns nothing
        call DebugEx(thistype.NAME + " Request running list:")

        call thistype.FOR_EACH_RUNNING_LIST_Set()

        loop
            local thistype this = thistype.FOR_EACH_RUNNING_LIST_FetchFirst()
            exitwhen (this == NULL)

            call DebugEx(Code.GetNameById(this.GetActionFunc()))
        endloop

        call DebugEx(thistype.NAME + " end of Request running list")
    endmethod

    method Start takes real timeout, boolean periodic, code actionFunction returns nothing
        call this.SetActionFunc(Code.GetId(actionFunction))
        call this.SetName(Code.GetName(actionFunction))
        call this.SetTimeout(timeout)
        call TimerStart(this.self, timeout, periodic, actionFunction)

        if periodic then
            call thistype.RUNNING_LIST_Add(this)
        endif
    endmethod

    static method StartPeriodicRange_Timeout takes nothing returns nothing
        local thistype this = Timer.GetExpired()

        call TimerStart(this.self, Math.Random(this.GetTimeoutMin(), this.GetTimeoutMax()), false, function thistype.StartPeriodicRange_Timeout)

        call this.GetAction().Run()
    endmethod

    method StartPeriodicRange takes real timeoutMin, real timeoutMax, code actionFunction returns nothing
        local real timeout = Math.Random(timeoutMin, timeoutMax)

        call this.SetAction(Trigger.GetFromCode(actionFunction))
        call this.SetActionFunc(Code.GetId(actionFunction))
        call this.SetName(Code.GetName(actionFunction))
        call this.SetTimeout(timeout)
        call this.SetTimeoutMax(timeoutMax)
        call this.SetTimeoutMin(timeoutMin)
        call TimerStart(this.self, timeout, false, function thistype.StartPeriodicRange_Timeout)

        call thistype.RUNNING_LIST_Add(this)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this

        if (thistype.QUEUE_SIZE == ARRAY_EMPTY) then
            set this = thistype.allocate()

			local timer self = CreateTimer()

            //set thistype.QUEUED[ARRAY_MIN] = this

            //set this.isRunning = false

            set this.self = self
            call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

            set self = null
            call this.Id.Event_Create()

            return this
        endif

        set this = thistype.QUEUED[thistype.QUEUE_SIZE]

        set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE - 1

		call this.SetName(null)
        call this.SetTimeout(0.)

        return this
    endmethod

    initMethod Init of Header_2
        call TimerDialog.Init()
        call TriggerTimer.Init()
    endmethod
endstruct