//! runtextmacro Folder("DestructableType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("DestructableType", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DestructableType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DestructableType", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DestructableType", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("DestructableType", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("DestructableType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "DestructableType", "NULL")

        //! runtextmacro Event_Implement("DestructableType")
    endstruct

    //! runtextmacro Struct("Preload")
        method Event_Create takes nothing returns nothing
            call RemoveDestructable(CreateDestructable(DestructableType(this).self, 0., 0., 0., 0., 0))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DestructableType", "DESTRUCTABLE_TYPE")
    //! runtextmacro GetKey("KEY")

    string name
    integer self

    //! runtextmacro LinkToStruct("DestructableType", "Data")
    //! runtextmacro LinkToStruct("DestructableType", "Event")
    //! runtextmacro LinkToStruct("DestructableType", "Id")
    //! runtextmacro LinkToStruct("DestructableType", "Preload")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return this.name
    endmethod

    method Name_Event_Create takes nothing returns nothing
        local destructable dummyDestructable = CreateDestructable(this.self, 0., 0., 0., 0., 0)

        set this.name = GetDestructableName(dummyDestructable)

        call RemoveDestructable(dummyDestructable)

        set dummyDestructable = null
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c)
    endmethod

    static method Create takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        call this.Name_Event_Create()
        call this.Id.Event_Create()
        call this.Preload.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        call Trigger.RunObjectInits(thistype.INIT_KEY_ARRAY)
    endmethod
endstruct

//! runtextmacro Folder("Destructable")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Destructable", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Destructable", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Destructable", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Destructable", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("Destructable", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Destructable")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro Destructable_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Destructable
                    return Destructable.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            //! runtextmacro Destructable_Event_Native_CreateResponse("Dying", "GetDyingDestructable")
            //! runtextmacro Destructable_Event_Native_CreateResponse("Filter", "GetFilterDestructable")
            //! runtextmacro Destructable_Event_Native_CreateResponse("Enum", "GetEnumDestructable")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Destructable", "NULL")

        //! runtextmacro Event_Implement("Destructable")
    endstruct

    //! runtextmacro Struct("Type")
        //! runtextmacro CreateSimpleAddState("DestructableType", "DestructableType.GetFromSelf(GetDestructableTypeId(Destructable(this).self))")
    endstruct

    //! runtextmacro Struct("TimedLife")
        static Event DEATH_EVENT
        //! runtextmacro GetKey("KEY")

        Timer durationTimer
        Destructable parent

        method Ending takes Timer durationTimer, Destructable parent returns nothing
            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(DEATH_EVENT)
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer, this.parent)

            call parent.Kill()
        endmethod

        static method Event_Death takes nothing returns nothing
            local Destructable parent = DESTRUCTABLE.Event.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, parent)
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local Destructable parent = this

            set this = thistype.allocate()
            set this.durationTimer = durationTimer
            set this.parent = parent
            call durationTimer.SetData(this)
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(DEATH_EVENT)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set DEATH_EVENT = Event.Create(Destructable.DEATH_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
        endmethod
    endstruct

    //! runtextmacro Folder("Enum")
        //! runtextmacro Struct("InRange")
            static Rectangle DUMMY_RECT
            static BoolExpr TARGET_FILTER

            static method Conditions takes nothing returns boolean
                local Destructable filterDestructable = DESTRUCTABLE.Event.Native.GetFilter()

                if (Math.DistanceSquareByDeltas(filterDestructable.x - TEMP_REAL, filterDestructable.y - TEMP_REAL2) > TEMP_REAL3) then
                    return false
                endif

                return true
            endmethod

            static method Do takes real x, real y, real areaRange, code action returns nothing
                call thistype.DUMMY_RECT.Set(x - areaRange, y - areaRange, x + areaRange, y + areaRange)

                set TEMP_REAL = x
                set TEMP_REAL2 = y
                set TEMP_REAL3 = areaRange * areaRange

                call EnumDestructablesInRect(thistype.DUMMY_RECT.self, thistype.TARGET_FILTER.self, action)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_RECT = Rectangle.Create(0., 0., 0., 0.)
                set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Enum")
        //! runtextmacro LinkToStruct("Enum", "InRange")

        static method Init takes nothing returns nothing
            call thistype(NULL).InRange.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Life")
        real value

        method Get takes nothing returns real
            return GetDestructableLife(Destructable(this).self)
        endmethod

        method Set takes real value returns nothing
            call SetDestructableLife(Destructable(this).self, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
    endstruct
endscope

//! runtextmacro BaseStruct("Destructable", "DESTRUCTABLE")
    static EventType CREATE_EVENT_TYPE
    static EventType DEATH_EVENT_TYPE
    static Trigger DEATH_TRIGGER
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro GetKey("KEY")

    destructable self
    real x
    real y
    real z

    //! runtextmacro LinkToStruct("Destructable", "Data")
    //! runtextmacro LinkToStruct("Destructable", "Enum")
    //! runtextmacro LinkToStruct("Destructable", "Event")
    //! runtextmacro LinkToStruct("Destructable", "Id")
    //! runtextmacro LinkToStruct("Destructable", "Life")
    //! runtextmacro LinkToStruct("Destructable", "TimedLife")
    //! runtextmacro LinkToStruct("Destructable", "Type")

    static method GetFromSelf takes destructable self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetDestructableName(this.self)
    endmethod

    method GetSelf takes nothing returns destructable
        return this.self
    endmethod

    method GetX takes nothing returns real
        return this.x
    endmethod

    method GetY takes nothing returns real
        return this.y
    endmethod

    method GetZ takes nothing returns real
        return this.z
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(this)
                call DESTRUCTABLE.Event.SetTrigger(this)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Destroy takes nothing returns nothing
        local destructable self = this.self

        call this.Destroy_TriggerEvents()

        call this.deallocate()
        call RemoveDestructable(self)

        set self = null
    endmethod

    method ApplyTimedLife takes real duration returns nothing
        call this.TimedLife.Start(duration)
    endmethod

    method Death_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.Event.Count(thistype.DEATH_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(this.Id.Get())
                call DESTRUCTABLE.Event.SetTrigger(this)

                call this.Event.Get(thistype.DEATH_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method Death_Trig takes nothing returns nothing
        call thistype(NULL).Event.Native.GetDying().Death_TriggerEvents()
    endmethod

    method Kill takes nothing returns nothing
        call KillDestructable(this.self)
    endmethod

    method Create_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority
        local DestructableType thisType = this.Type.Get()

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(0)
                call DESTRUCTABLE.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = thisType.Event.Count(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(thisType.Id.Get())
                call DESTRUCTABLE.Event.SetTrigger(this)

                call thisType.Event.Get(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method CreateFromSelf takes destructable self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        set this.x = GetDestructableX(self)
        set this.y = GetDestructableY(self)
        set this.z = 0.
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.Id.Event_Create()
        call this.Type.Event_Create()

        call thistype.DEATH_TRIGGER.RegisterEvent.DestructableDeath(this)

        call this.Create_TriggerEvents()

        return this
    endmethod

    static method Create takes DestructableType whichType, real x, real y, real z, real angle, real scale, integer variation returns thistype
        local destructable self = CreateDestructableZ(whichType.self, x, y, z, angle * Math.RAD_TO_DEG, scale, variation)
        local thistype this = thistype.allocate()

        set this.self = self
        set this.x = x
        set this.y = y
        set this.z = z
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        set self = null
        call this.Id.Event_Create()
        call this.Type.Event_Create()

        call thistype.DEATH_TRIGGER.RegisterEvent.DestructableDeath(this)

        call this.Create_TriggerEvents()

        return this
    endmethod

    static method Start_Enum takes nothing returns nothing
        local destructable enumDestructableSelf = GetEnumDestructable()

        if (thistype.GetFromSelf(enumDestructableSelf) == NULL) then
            call thistype.CreateFromSelf(enumDestructableSelf)
        endif

        set enumDestructableSelf = null
    endmethod

    static method Event_Start takes nothing returns nothing
        call EnumDestructablesInRect(Rectangle.WORLD.self, null, function thistype.Start_Enum)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CREATE_EVENT_TYPE = EventType.Create()
        set thistype.DEATH_EVENT_TYPE = EventType.Create()
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.DEATH_TRIGGER = Trigger.CreateFromCode(function thistype.Death_Trig)
        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        call thistype(NULL).Enum.Init()
        call thistype(NULL).TimedLife.Init()

        call DestructableType.Init()
    endmethod
endstruct