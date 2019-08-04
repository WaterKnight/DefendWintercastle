//! runtextmacro BaseStruct("DefenderSpawnLocation", "DEFENDER_SPAWN_LOCATION")
    static thistype SOURCE_CENTER

    static thistype TARGET_BOTTOM
    static thistype TARGET_LEFT
    static thistype TARGET_RIGHT

    Rectangle source

    method GetCenterX takes nothing returns real
        return this.source.GetCenterX()
    endmethod

    method GetCenterY takes nothing returns real
        return this.source.GetCenterY()
    endmethod

    method RandomX takes nothing returns real
        return this.source.RandomX()
    endmethod

    method RandomY takes nothing returns real
        return this.source.RandomY()
    endmethod

    static method Create takes Rectangle source returns thistype
        local thistype this = thistype.allocate()

        set this.source = source

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.SOURCE_CENTER = thistype.Create(Rectangle.CreateFromSelf(gg_rct_DefenderSpawn_SourceCenter))

        set thistype.TARGET_BOTTOM = thistype.Create(Rectangle.CreateFromSelf(gg_rct_DefenderSpawn_TargetBottom))
        set thistype.TARGET_LEFT = thistype.Create(Rectangle.CreateFromSelf(gg_rct_DefenderSpawn_TargetLeft))
        set thistype.TARGET_RIGHT = thistype.Create(Rectangle.CreateFromSelf(gg_rct_DefenderSpawn_TargetRight))
    endmethod
endstruct

//! runtextmacro Folder("DefenderSpawnType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DefenderSpawnType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DefenderSpawnType", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("DefenderSpawnType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("DefenderSpawnType")
    endstruct
endscope

//! runtextmacro BaseStruct("DefenderSpawnType", "DEFENDER_SPAWN_TYPE")
    //! runtextmacro GetKey("KEY")

    //Bonus

    //Act1
    static thistype VICAR
    static thistype SWORDSMAN

    //Act2

    //! runtextmacro LinkToStruct("DefenderSpawnType", "Data")
    //! runtextmacro LinkToStruct("DefenderSpawnType", "Event")
    //! runtextmacro LinkToStruct("DefenderSpawnType", "Id")

    //! runtextmacro CreateAnyState("whichType", "Type", "UnitType")

    static method Create takes UnitType whichUnitType returns thistype
        local thistype this = thistype.allocate()

        call this.SetType(whichUnitType)

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        local thistype this

        //Bonus

        //Act1
            //Priest
            set this = thistype.Create(UnitType.VICAR)
            set this = thistype.Create(UnitType.VICAR)
            set this = thistype.Create(UnitType.VICAR)

            set thistype.VICAR = this

            //Swordman
            set this = thistype.Create(UnitType.SWORDSMAN)
            set this = thistype.Create(UnitType.SWORDSMAN)
            set this = thistype.Create(UnitType.SWORDSMAN)

            set thistype.SWORDSMAN = this

        //Act2
    endmethod
endstruct

//! runtextmacro Folder("DefenderSpawnGroup")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DefenderSpawnGroup", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DefenderSpawnGroup", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("DefenderSpawnGroup")
    endstruct
endscope

//! runtextmacro BaseStruct("DefenderSpawnGroup", "DEFENDER_SPAWN_GROUP")
    //! runtextmacro GetKeyArray("TYPES_KEY_ARRAY")

    //! runtextmacro LinkToStruct("DefenderSpawnGroup", "Data")
    //! runtextmacro LinkToStruct("DefenderSpawnGroup", "Id")

    //! runtextmacro CreateAnyState("source", "Source", "DefenderSpawnLocation")
    //! runtextmacro CreateAnyState("target", "Target", "DefenderSpawnLocation")

    method Run takes nothing returns nothing
        local DefenderSpawnLocation source = this.source
        local DefenderSpawnLocation target = this.target

        local real sourceX = source.GetCenterX()
        local real sourceY = source.GetCenterY()

		local integer count = this.Data.Integer.Table.Count(TYPES_KEY_ARRAY)
		local Group dummyGroup = Group.Create()
		local integer iteration = Memory.IntegerKeys.Table.STARTED

        loop
            exitwhen (iteration > count)

            local DefenderSpawnType whichType = this.Data.Integer.Table.Get(TYPES_KEY_ARRAY, iteration)

            call dummyGroup.AddUnit(DefenderSpawn.AddNew(whichType, whichType.GetType(), sourceX, sourceY, UNIT.Facing.STANDARD))

            set iteration = iteration + 1
        endloop

        call dummyGroup.Order.IssuePointTarget(Order.ATTACK, target.RandomX(), target.RandomY())

        call dummyGroup.Destroy()
    endmethod

    static method Create takes DefenderSpawnLocation source, DefenderSpawnLocation target returns thistype
        local thistype this = thistype.allocate()

        call this.SetSource(source)
        call this.SetTarget(target)

        call this.Id.Event_Create()

        return this
    endmethod

    method AddType takes DefenderSpawnType whichType returns nothing
        call this.Data.Integer.Table.AddMulti(TYPES_KEY_ARRAY, whichType)
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("DefenderSpawnWave")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DefenderSpawnWave", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DefenderSpawnWave", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("DefenderSpawnWave")
    endstruct

    //! runtextmacro Struct("Groups")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Run takes nothing returns nothing
            local DefenderSpawnWave parent = this

            local integer count = parent.Data.Integer.Table.Count(KEY_ARRAY)
			local integer iteration = Memory.IntegerKeys.Table.STARTED

            loop
                exitwhen (iteration > count)

                local DefenderSpawnGroup currentGroup = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call currentGroup.Run()

                set iteration = iteration + 1
            endloop
        endmethod

        method Add takes DefenderSpawnGroup value returns nothing
            call DefenderSpawnWave(this).Data.Integer.Table.Add(KEY_ARRAY, value)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DefenderSpawnWave", "DEFENDER_SPAWN_WAVE")
    //! runtextmacro GetKey("KEY")

    Level whichLevel

    //! runtextmacro LinkToStruct("DefenderSpawnWave", "Data")
    //! runtextmacro LinkToStruct("DefenderSpawnWave", "Groups")
    //! runtextmacro LinkToStruct("DefenderSpawnWave", "Id")

    //! runtextmacro CreateAnyState("waitBefore", "WaitBefore", "real")

    static method GetFromLevel takes Level whichLevel returns thistype
        return whichLevel.Data.Integer.Get(KEY)
    endmethod

    method Run takes nothing returns nothing
        call this.Groups.Run()
    endmethod

    method SetLevel takes Level value returns nothing
        set this.whichLevel = value
        call value.Data.Integer.Set(KEY, this)
    endmethod

    static method CreateFromLevel takes Level whichLevel returns thistype
        local thistype this = thistype.allocate()

        call this.SetLevel(whichLevel)
        call this.SetWaitBefore(20.)

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
		local integer iteration = Level.ALL_COUNT        
        local integer thisTypeIndex

        loop
            exitwhen (iteration < ARRAY_MIN)

            local Level currentLevel = Level.ALL[iteration]

            if not currentLevel.IsBonus() then
                local thistype this = thistype.CreateFromLevel(currentLevel)

                local DefenderSpawnGroup currentGroup = DefenderSpawnGroup.Create(DefenderSpawnLocation.SOURCE_CENTER, DefenderSpawnLocation.TARGET_LEFT)

                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.VICAR)
                call this.Groups.Add(currentGroup)

                set currentGroup = DefenderSpawnGroup.Create(DefenderSpawnLocation.SOURCE_CENTER, DefenderSpawnLocation.TARGET_RIGHT)

                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.VICAR)
                call this.Groups.Add(currentGroup)

                set currentGroup = DefenderSpawnGroup.Create(DefenderSpawnLocation.SOURCE_CENTER, DefenderSpawnLocation.TARGET_BOTTOM)

                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.SWORDSMAN)
                call currentGroup.AddType(DefenderSpawnType.VICAR)
                call this.Groups.Add(currentGroup)
            endif

            set iteration = iteration - 1
        endloop

        //Act1
            //Standard

        //Act2

        //Bonus
    endmethod
endstruct

//! runtextmacro BaseStruct("DefenderSpawn", "DEFENDER_SPAWN")
    static Group ALL_GROUP
    static EventType DUMMY_EVENT_TYPE

    static method RemoveAllUnits takes nothing returns nothing
        loop
            local Unit spawn = thistype.ALL_GROUP.FetchFirst()
            exitwhen (spawn == NULL)

            call spawn.Destroy()
        endloop
    endmethod

    static method Add_TriggerEvents takes DefenderSpawnType whichType, Unit whichUnit returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.DefenderSpawnType.SetTrigger(whichType)
        call params.Unit.SetTrigger(whichUnit)

		local EventResponse typeParams = EventResponse.Create(whichType.Id.Get())

        call typeParams.DefenderSpawnType.SetTrigger(whichType)
        call typeParams.Unit.SetTrigger(whichUnit)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = whichType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call whichType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(typeParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
        call typeParams.Destroy()
    endmethod

    static method AddNew takes DefenderSpawnType whichType, UnitType whichTypeUnitType, real x, real y, real angle returns Unit
        local Unit newUnit = Unit.Create(whichTypeUnitType, User.CASTLE, x, y, angle)

        //call RemoveGuardPosition(newUnit.self)

        call thistype.ALL_GROUP.AddUnit(newUnit)

        call thistype.Add_TriggerEvents(whichType, newUnit)

        return newUnit
    endmethod

    eventMethod Event_LevelStart
        local DefenderSpawnWave thisWave = DefenderSpawnWave.GetFromLevel(params.Level.GetTrigger())

        call thisWave.Run()
    endmethod

    eventMethod Event_Start
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    initMethod Init of Misc_4
        set thistype.ALL_GROUP = Group.Create()
        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()

        call DefenderSpawnLocation.Init()
        call DefenderSpawnType.Init()

        call DefenderSpawnWave.Init()
    endmethod
endstruct