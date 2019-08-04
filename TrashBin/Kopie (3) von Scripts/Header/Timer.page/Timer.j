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
        local timer self = CreateTimer()
        local thistype this = thistype.allocate()

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

    timer self

    //! runtextmacro LinkToStruct("Timer", "Data")
    //! runtextmacro LinkToStruct("Timer", "Id")

    //! runtextmacro CreateAnyState("data", "Data", "integer")
    //! runtextmacro CreateAnyState("timeout", "Timeout", "real")

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

    method GetRemaining takes nothing returns real
        return TimerGetRemaining(this.self)
    endmethod

    method Pause takes nothing returns nothing
        call PauseTimer(this.self)
    endmethod

    method Abort takes nothing returns nothing
        call this.Pause()
        call this.SetTimeout(0.)
    endmethod
    /*method Pause takes nothing returns nothing
        if (this.isRunning == false) then
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

    /*static thistype FIRST_TO_RUN = NULL
    static thistype TEMP
    static constant real TICK_TIME_OUT = 2. / 32.

    trigger action
    integer initialTicks
    boolean isPeriodic
    boolean isRunning
    thistype next
    thistype prev
    integer remainingTicks

    method Restart takes nothing returns nothing
        local thistype next
        local thistype prev
        local integer remainingTicks = this.initialTicks

        if (thistype.FIRST_TO_RUN == NULL) then
            set thistype.FIRST_TO_RUN = this
            set this.next = NULL
        else
            set next = thistype.FIRST_TO_RUN
            set prev = NULL

            loop
                exitwhen (remainingTicks < next.remainingTicks)

                set prev = next

                set next = next.next

                exitwhen (next == NULL)
            endloop

            if (prev == NULL) then
                set thistype.FIRST_TO_RUN = this
                set this.next = next
            else
                if (next == NULL) then
                    set this.next = NULL
                else
                    set next.prev = this
                    set this.next = next
                endif

                set prev.next = this
                set this.prev = prev
            endif
        endif

        set this.isRunning = true
        set this.remainingTicks = remainingTicks
    endmethod

    static trigger TEMP_TRIG
    static hashtable CACHE

    static method GetTriggerFromCode takes code c returns trigger
        local integer id = Code.GetId(c)

        set TEMP_TRIG = LoadTriggerHandle(CACHE, id, 0)

        if (TEMP_TRIG == null) then
            set TEMP_TRIG = CreateTrigger()

            call TriggerAddCondition(TEMP_TRIG, Condition(c))

            call SaveTriggerHandle(CACHE, id, 0, TEMP_TRIG)
        endif

        return TEMP_TRIG
    endmethod

    method Start takes real timeout, boolean periodic, code action returns nothing
        local thistype next
        local thistype prev
        local integer i=0

        if (this.isRunning) then
            call this.Pause()
        endif

        set remainingTicks = R2I(timeout / thistype.TICK_TIME_OUT + 0.5)

        /*if (remainingTicks == 0) then
            call TimerStart()
        endif*/

        if (thistype.FIRST_TO_RUN == NULL) then
            set thistype.FIRST_TO_RUN = this
            set this.next = NULL
        else
            set next = thistype.FIRST_TO_RUN
            set prev = NULL

            loop
                exitwhen (remainingTicks < next.remainingTicks)

                set prev = next

                set next = next.next

                exitwhen (next == NULL)
            endloop

            if (prev == NULL) then
                set thistype.FIRST_TO_RUN = this
                set this.next = next
            else
                if (next == NULL) then
                    set this.next = NULL
                else
                    set next.prev = this
                    set this.next = next
                endif

                set prev.next = this
                set this.prev = prev
            endif
        endif

        set this.action = GetTriggerFromCode(action)
        set this.initialTicks = remainingTicks
        set this.isPeriodic = periodic
        set this.isRunning = true
        set this.remainingTicks = remainingTicks
    endmethod

    static method Tick takes nothing returns nothing
        local integer i = -1
        local integer iEnd
        local thistype array temp
        local thistype array temp2
        local thistype this = thistype.FIRST_TO_RUN

        loop
            exitwhen (this == NULL)

            set i = i + 1

            set temp[i] = this
            set this.remainingTicks = this.remainingTicks - 1

            set this = this.next
        endloop

        set iEnd = i
        set temp[i + 1] = NULL

        set i = 0

        loop
            exitwhen (i > iEnd)

            set this = temp[i]

            if (this.remainingTicks < 1) then
                call this.Pause()

                if (this.isPeriodic) then
                    call this.Restart()
                endif

                set thistype.TEMP = this

                call TriggerEvaluate(this.action)
            endif

            set i = i + 1
        endloop
    endmethod

    static method Tick2 takes nothing returns nothing
        local integer i = -1
        local integer i2 = -1
        local integer iEnd
        local thistype array temp
        local thistype array temp2
        local thistype this = thistype.FIRST_TO_RUN

        loop
            exitwhen (this == NULL)

            set i = i + 1

            set temp[i] = this
            set this.remainingTicks = this.remainingTicks - 1

            set this = this.next
        endloop

        set iEnd = i

        set i = 0

        loop
            exitwhen (i > iEnd)

            set this = temp[i]

            if (this.remainingTicks < 1) then
                set thistype.FIRST_TO_RUN = temp[i + 1]

                if (this.isPeriodic) then
                    call temp2[i].Restart()
                else
                    set this.isRunning = false
                endif

                set i2 = i2 + 1

                set temp2[i2] = this
            endif

            set i = i + 1
        endloop

        set iEnd = i2

        set i = 0

        loop
            exitwhen (i > iEnd)

            if (temp2[i].isRunning and (temp2[i].remainingTicks < 1)) then
                set thistype.TEMP = temp2[i]

                call TriggerEvaluate(temp2[i].action)
            endif

            set i = i + 1
        endloop
    endmethod

    static method onInit takes nothing returns nothing
        set thistype.CACHE = InitHashtable()

        call TimerStart(CreateTimer(), thistype.TICK_TIME_OUT, true, function thistype.Tick)
    endmethod*/

    method Start takes real timeout, boolean periodic, code actionFunction returns nothing
        call this.SetTimeout(timeout)
        call TimerStart(this.self, timeout, periodic, actionFunction)
    endmethod

    static method Create takes nothing returns thistype
        local timer self
        local thistype this

        if (thistype.QUEUE_SIZE == ARRAY_EMPTY) then
            set self = CreateTimer()
            set this = thistype.allocate()

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

        call this.SetTimeout(0.)

        return this
    endmethod

    static method Init takes nothing returns nothing
        call TimerDialog.Init()
        call TriggerTimer.Init()
    endmethod
endstruct