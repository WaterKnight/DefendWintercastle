//! runtextmacro BaseStruct("UbersplatType", "UBERSPLAT_TYPE")
    string self

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod
endstruct

//! runtextmacro Folder("Ubersplat")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Ubersplat", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Ubersplat", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Ubersplat")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Ubersplat")
    endstruct

    //! runtextmacro Struct("DestroyTimed")
        Timer durationTimer

        method Ending takes nothing returns nothing
            call this.durationTimer.Destroy()
        endmethod

        timerMethod EndingByTimer
            local thistype this = Timer.GetExpired().GetData()

            call this.Ending()

            call Ubersplat(this).Destroy()
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)

            call Ubersplat(this).Color.Timed.Subtract(0., 0., 0., Ubersplat(this).Color.Alpha.Get(), duration)
        endmethod
    endstruct

    //! runtextmacro Folder("Color")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
            static Timer UPDATE_TIMER

            real redAdd
            real greenAdd
            real blueAdd
            real alphaAdd
            Timer durationTimer
            Ubersplat parent

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.Color.Add(this.redAdd, this.greenAdd, this.blueAdd, this.alphaAdd)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            private method Ending takes Timer durationTimer, Ubersplat parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)
                call parent.Event.Remove(DESTROY_EVENT)
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Destroy
                local Ubersplat parent = params.Ubersplat.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                if (iteration > Memory.IntegerKeys.Table.EMPTY) then
                    loop
                        local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endif
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            method Add takes real red, real green, real blue, real alpha, real duration returns nothing
                local Ubersplat parent = this

                if (duration == 0.) then
                    call parent.Color.Add(red, green, blue, alpha)

                    return
                endif

				local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

				set this = thistype.allocate()

                local Timer durationTimer = Timer.Create()

                set this.redAdd = red / wavesAmount
                set this.greenAdd = green / wavesAmount
                set this.blueAdd = blue / wavesAmount
                set this.alphaAdd = alpha / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                call parent.Event.Add(DESTROY_EVENT)

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real red, real green, real blue, real alpha, real duration returns nothing
                call this.Add(-red, -green, -blue, -alpha, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Ubersplat.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Color")
        //! runtextmacro LinkToStruct("Color", "Red")
        //! runtextmacro LinkToStruct("Color", "Green")
        //! runtextmacro LinkToStruct("Color", "Blue")
        //! runtextmacro LinkToStruct("Color", "Alpha")

        //! runtextmacro LinkToStruct("Color", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real red, real green, real blue, real alpha returns nothing
            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)

            call Ubersplat(this).Recreate()
        endmethod

        method Add takes real red, real green, real blue, real alpha returns nothing
            call this.Set(this.Red.Get() + red, this.Green.Get() + green, this.Blue.Get() + blue, this.Alpha.Get() + alpha)
        endmethod

        method Subtract takes real red, real green, real blue, real alpha returns nothing
            call this.Add(-red, -green, -blue, -alpha)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        method Event_Create takes real red, real green, real blue, real alpha returns nothing
            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Position")
        //! runtextmacro Struct("X")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real val returns nothing
                set this.value = val

                call Ubersplat(this).Recreate()
            endmethod

            method Event_Create takes real val returns nothing
                set this.value = val
            endmethod
        endstruct

        //! runtextmacro Struct("Y")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real val returns nothing
                set this.value = val

                call Ubersplat(this).Recreate()
            endmethod

            method Event_Create takes real val returns nothing
                set this.value = val
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Position")
        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")

        method Set takes real x, real y returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)
        endmethod

        method Add takes real x, real y returns nothing
            call this.Set(this.X.Get() + x, this.Y.Get() + y)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.X.Get(), this.Y.Get())
        endmethod

        method Event_Create takes real x, real y returns nothing
            call this.X.Event_Create(x)
            call this.Y.Event_Create(y)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Ubersplat", "UBERSPLAT")
    static EventType DESTROY_EVENT_TYPE

    ubersplat self
    boolean selfCreated

    //! runtextmacro CreateAnyFlagState("noBirthTime", "NoBirthTime")
    //! runtextmacro CreateAnyFlagState("forcePaused", "ForcePaused")
    //! runtextmacro CreateAnyState("whichType", "Type", "UbersplatType")

    //! runtextmacro LinkToStruct("Ubersplat", "Data")
    //! runtextmacro LinkToStruct("Ubersplat", "Id")
    //! runtextmacro LinkToStruct("Ubersplat", "Event")

    //! runtextmacro LinkToStruct("Ubersplat", "Color")
    //! runtextmacro LinkToStruct("Ubersplat", "DestroyTimed")
    //! runtextmacro LinkToStruct("Ubersplat", "Position")

    method ContainsSelf takes nothing returns boolean
        return this.selfCreated
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Ubersplat.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Recreate takes nothing returns nothing
        if this.ContainsSelf() then
            call DestroyUbersplat(this.self)
        endif

        set this.self = CreateUbersplat(this.Position.X.Get(), this.Position.Y.Get(), this.GetType().self, Math.LimitI(Real.ToInt(this.Color.Red.Get()), 0, 255), Math.LimitI(Real.ToInt(this.Color.Green.Get()), 0, 255), Math.LimitI(Real.ToInt(this.Color.Blue.Get()), 0, 255), Math.LimitI(Real.ToInt(this.Color.Alpha.Get()), 0, 255), this.IsForcePaused(), this.IsNoBirthTime())
        set this.selfCreated = (GetHandleId(this.self) != -1)

        call SetUbersplatRenderAlways(this.self, true)
    endmethod

    method Destroy takes nothing returns nothing
        call this.Destroy_TriggerEvents()

        if this.ContainsSelf() then
            call DestroyUbersplat(this.self)
        endif

        call this.deallocate()
    endmethod

    static method Create takes UbersplatType whichType, real x, real y, real red, real green, real blue, real alpha, boolean forcePaused, boolean noBirthTime returns thistype
        local thistype this = thistype.allocate()

        set this.self = null
        set this.selfCreated = false

        call this.Id.Event_Create()

        call this.SetForcePaused(forcePaused)
        call this.SetNoBirthTime(noBirthTime)
        call this.SetType(whichType)

        call this.Color.Event_Create(red, green, blue, alpha)
        call this.Position.Event_Create(x, y)

        call this.Recreate()

        return this
    endmethod

    initMethod Init of Header_5
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        call thistype(NULL).Color.Init()
    endmethod
endstruct