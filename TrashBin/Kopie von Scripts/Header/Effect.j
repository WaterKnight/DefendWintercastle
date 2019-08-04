//! runtextmacro BaseStruct("EffectLevel", "EFFECT_LEVEL")
    static thistype CURRENT

    static thistype LOW
    static thistype NORMAL

    //! runtextmacro CreateAnyState("name", "Name", "string")

    method operator< takes thistype other returns boolean
        return (this.index < other.index)
    endmethod

    /*method operator> takes thistype other returns boolean
        return (this.index > other.index)
    endmethod*/

    static method Random takes thistype this, thistype other returns thistype
        return thistype.ALL[Math.RandomI(this.index, other.index)]
    endmethod

    method Select takes nothing returns nothing
        set thistype.CURRENT = this

        call UnitEffect.UpdateAll()
    endmethod

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetName(name)

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.LOW = thistype.Create("low")
        set thistype.NORMAL = thistype.Create("normal")

        set thistype.CURRENT = thistype.NORMAL
    endmethod
endstruct

//! runtextmacro Folder("SpotEffectWithSize")
    //! runtextmacro Struct("DestroyTimed")
        //! runtextmacro GetKey("KEY")

        SpotEffectWithSize parent

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local SpotEffectWithSize parent = this.parent

            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Destroy()
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local SpotEffectWithSize parent = this

            set this = thistype.allocate()
            set this.parent = parent
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpotEffectWithSize", "SPOT_EFFECT_WITH_SIZE")
    static constant string DUMMY_UNIT_ATTACH_POINT = AttachPoint.ORIGIN
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dEWS", "Effect Sizer", "DUMMY_UNIT_ID", "Other\\EffectSizer\\EffectSizer.mdl")

    DummyUnit dummyUnit
    effect self

    //! runtextmacro LinkToStruct("SpotEffectWithSize", "DestroyTimed")

    method Destroy takes nothing returns nothing
        local DummyUnit dummyUnit = this.dummyUnit
        local effect self = this.self

        call this.deallocate()
        call dummyUnit.Destroy()
        call DestroyEffect(self)

        set self = null
    endmethod

    static method Create takes real x, real y, string modelPath, EffectLevel level, real size returns thistype
        local DummyUnit dummyUnit = DummyUnit.Create(DUMMY_UNIT_ID, x, y, Spot.GetHeight(x, y), DUMMY_UNIT.Facing.STANDARD)
        local thistype this = thistype.allocate()

        set this.dummyUnit = dummyUnit
        set this.self = AddSpecialEffectTarget(String.If(EffectLevel.CURRENT >= level, modelPath), dummyUnit.self, thistype.DUMMY_UNIT_ATTACH_POINT)

        call dummyUnit.Scale.Set(size)

        return this
    endmethod

    static method CreateWithZ takes real x, real y, real z, string modelPath, EffectLevel level, real size returns thistype
        local thistype this = thistype.Create(x, y, modelPath, level, size)

        call this.dummyUnit.Position.Z.Set(z)

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("DummyUnitEffect", "DUMMY_UNIT_EFFECT")
    static Event DEATH_EVENT
    static Event DESTROY_EVENT
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    DummyUnit dummyUnit
    effect self

    method Destroy takes nothing returns nothing
        local DummyUnit dummyUnit = this.dummyUnit
        local effect self = this.self

        call this.deallocate()
        call DestroyEffect(self)

        set self = null

        if (dummyUnit.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call dummyUnit.Event.Remove(DEATH_EVENT)
            call dummyUnit.Event.Remove(DESTROY_EVENT)
        endif
    endmethod

    static method Event_Death takes nothing returns nothing
        local DummyUnit dummyUnit = DUMMY_UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = dummyUnit.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = dummyUnit.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Event_Destroy takes nothing returns nothing
        local DummyUnit dummyUnit = DUMMY_UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = dummyUnit.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = dummyUnit.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Create takes DummyUnit dummyUnit, string modelPath, string attachPoint, EffectLevel level returns thistype
        local thistype this = thistype.allocate()

        set this.dummyUnit = dummyUnit
        set this.self = AddSpecialEffectTarget(String.If(EffectLevel.CURRENT >= level, modelPath), dummyUnit.self, attachPoint)

        if (dummyUnit.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call dummyUnit.Event.Add(DEATH_EVENT)
            call dummyUnit.Event.Add(DESTROY_EVENT)
        endif

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(DummyUnit.DEATH_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
        set thistype.DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
    endmethod
endstruct

//! runtextmacro Folder("SpotEffect")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("SpotEffect", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("SpotEffect", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("SpotEffect", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("SpotEffect")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "SpotEffect", "NULL")

        //! runtextmacro Event_Implement("SpotEffect")
    endstruct

    //! runtextmacro Struct("DestroyTimed")
        //! runtextmacro GetKey("KEY")

        SpotEffect parent

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local SpotEffect parent = this.parent

            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Destroy()
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local SpotEffect parent = this

            set this = thistype.allocate()
            set this.parent = parent
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpotEffect", "SPOT_EFFECT")
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro DummyDestructable_CreateSimpleType("/", "dEfL", "Effect Lifter", "WITH_Z_DUMMY_DESTRUCTABLE_ID", "Doodads\\Terrain\\InvisiblePlatform\\InvisiblePlatform.mdl", "true")
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    EffectLevel level
    string modelPath
    effect self
    real x
    real y

    //! runtextmacro LinkToStruct("SpotEffect", "DestroyTimed")
    //! runtextmacro LinkToStruct("SpotEffect", "Data")
    //! runtextmacro LinkToStruct("SpotEffect", "Event")
    //! runtextmacro LinkToStruct("SpotEffect", "Id")

    method Destroy takes nothing returns nothing
        local effect self = this.self

        call this.deallocate()
        if (self != null) then
            call DestroyEffect(self)

            set self = null
        endif
    endmethod

    method Hide takes nothing returns nothing
        call DestroyEffect(this.self)

        set this.self = null
    endmethod

    method Show takes nothing returns nothing
        set this.self = AddSpecialEffect(String.If(EffectLevel.CURRENT >= this.level, this.modelPath), this.x, this.y)
    endmethod

    static method Create takes real x, real y, string modelPath, EffectLevel level returns thistype
        local thistype this = thistype.allocate()

        set this.level = level
        set this.modelPath = modelPath
        set this.x = x
        set this.y = y

        call this.Show()

        return this
    endmethod

    static method CreateOnDestructable takes Destructable whichDestructable, string modelPath, EffectLevel level returns thistype
        return thistype.Create(whichDestructable.x, whichDestructable.y, modelPath, level)
    endmethod

    static method CreateWithZ takes real x, real y, real z, string modelPath, EffectLevel level returns thistype
        local destructable dummyDestructable = CreateDestructableZ(thistype.WITH_Z_DUMMY_DESTRUCTABLE_ID, x, y, z, 0., 1., 0)
        local thistype this

        set this = thistype.Create(x, y, modelPath, level)

        call RemoveDestructable(dummyDestructable)

        set dummyDestructable = null

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
    endmethod
endstruct

//! runtextmacro Folder("UnitEffect")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitEffect", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("UnitEffect", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitEffect", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("UnitEffect")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "UnitEffect", "NULL")

        //! runtextmacro Event_Implement("UnitEffect")
    endstruct

    //! runtextmacro Struct("DestroyTimed")
        //! runtextmacro GetKey("KEY")

        UnitEffect parent

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local UnitEffect parent = this.parent

            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Destroy()
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local UnitEffect parent = this

            set this = thistype.allocate()
            set this.parent = parent
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.Ending)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("UnitEffect", "UNIT_EFFECT")
    static Event DESTROY_EVENT
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static Event UNIT_DEATH_EVENT
    static Event UNIT_REVIVE_EVENT
    static Event UNIT_DESTROY_EVENT

    string attachPoint
    boolean dead
    EffectLevel level
    string modelPath
    effect self
    Unit whichUnit

    //! runtextmacro LinkToStruct("UnitEffect", "DestroyTimed")
    //! runtextmacro LinkToStruct("UnitEffect", "Data")
    //! runtextmacro LinkToStruct("UnitEffect", "Event")
    //! runtextmacro LinkToStruct("UnitEffect", "Id")

    method Ending takes Unit whichUnit returns nothing
        call this.Event.Remove(DESTROY_EVENT)
        if (whichUnit.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call whichUnit.Event.Remove(UNIT_DESTROY_EVENT)
            if (dead) then
                call whichUnit.Event.Remove(UNIT_REVIVE_EVENT)
            else
                call whichUnit.Event.Remove(UNIT_DEATH_EVENT)
            endif
        endif
    endmethod

    static method Event_Destroy takes nothing returns nothing
        local thistype this = UNIT_EFFECT.Event.GetTrigger()

        local Unit whichUnit = this.whichUnit

        call this.Ending(whichUnit)
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

                call UNIT_EFFECT.Event.SetTrigger(this)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Destroy takes nothing returns nothing
        local effect self = this.self

        call this.Destroy_TriggerEvents()

        call this.deallocate()

        call this.RemoveFromList()

        if (self != null) then
            call DestroyEffect(self)

            set self = null
        endif
    endmethod

    static method Event_Unit_Destroy takes nothing returns nothing
        local thistype this
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local integer iteration = whichUnit.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = whichUnit.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    method Hide takes nothing returns nothing
        call DestroyEffect(this.self)

        set this.self = null
    endmethod

    method Show takes nothing returns nothing
        set this.self = AddSpecialEffectTarget(String.If(EffectLevel.CURRENT >= this.level, this.modelPath), this.whichUnit.self, this.attachPoint)
    endmethod

    static method UpdateAll takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT
        local thistype this

        loop
            exitwhen (iteration < ARRAY_EMPTY)

            set this = thistype.ALL[iteration]

            if (this.self == null) then
                if (EffectLevel.CURRENT >= this.level) then
                    call this.Show()
                endif
            else
                if (EffectLevel.CURRENT < this.level) then
                    call this.Hide()
                endif
            endif

            set iteration = iteration - 1
        endloop
    endmethod

    static method Event_Unit_Death takes nothing returns nothing
        local thistype this
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local integer iteration = whichUnit.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = whichUnit.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Hide()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

        set this.dead = true
        call whichUnit.Event.Remove(UNIT_DEATH_EVENT)
        call whichUnit.Event.Add(UNIT_REVIVE_EVENT)
    endmethod

    static method Event_Unit_Revive takes nothing returns nothing
        local thistype this
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local integer iteration = whichUnit.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = whichUnit.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Show()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

        set this.dead = false
        call whichUnit.Event.Remove(UNIT_REVIVE_EVENT)
        call whichUnit.Event.Add(UNIT_DEATH_EVENT)
    endmethod

    static method Create takes Unit whichUnit, string modelPath, string attachPoint, EffectLevel level returns thistype
        local boolean hidden = false
        local thistype this = thistype.allocate()

        set this.attachPoint = attachPoint
        set this.level = level
        set this.modelPath = modelPath
        set this.whichUnit = whichUnit
        if (whichUnit.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            if (whichUnit.Classes.Contains(UnitClass.DEAD)) then
                set hidden = true
                set this.dead = true
                call whichUnit.Event.Add(UNIT_REVIVE_EVENT)
            else
                set this.dead = false
                call whichUnit.Event.Add(UNIT_DEATH_EVENT)
            endif
            call whichUnit.Event.Add(UNIT_DESTROY_EVENT)
        endif

        if (hidden) then
            set this.self = null
        else
            call this.Show()
        endif

        call this.Id.Event_Create()

        call this.Event.Add(DESTROY_EVENT)

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        set thistype.DESTROY_EVENT = Event.Create(thistype.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        set thistype.UNIT_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Unit_Death)
        set thistype.UNIT_DESTROY_EVENT = Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Unit_Destroy)
        set thistype.UNIT_REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Unit_Revive)
        call BJDebugMsg("effectEvents "+I2S(DESTROY_EVENT)+";"+I2S(UNIT_DEATH_EVENT)+";"+I2S(UNIT_DESTROY_EVENT)+";"+I2S(UNIT_REVIVE_EVENT))
    endmethod
endstruct

//! runtextmacro BaseStruct("Effect", "EFFECT")
    static method PreloadPath takes string path returns nothing
        call DestroyEffect(AddSpecialEffect(path, 0., 0.))
    endmethod

    static method Init takes nothing returns nothing
        //call EffectLevel.Init()

        call DummyUnitEffect.Init()
        call SpotEffect.Init()
        call SpotEffectWithSize.Init()
        call UnitEffect.Init()
    endmethod
endstruct