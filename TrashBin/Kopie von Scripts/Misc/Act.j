//! runtextmacro Folder("Act")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Act", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Act", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Act")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticState("TRIGGER", "Trigger", "Act" "NULL")

        //! runtextmacro Event_Implement("Act")
    endstruct
endscope

//! runtextmacro BaseStruct("Act", "ACT")
    static EventType ENDING_EVENT_TYPE
    //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY")
    static EventType START_EVENT_TYPE

    static thistype CURRENT

    static thistype BONUS
    static thistype FIRST
    static thistype SECOND
    static thistype THIRD
    static thistype FOURTH
    static thistype FIFTH
    static thistype SIXTH

    //! runtextmacro LinkToStruct("Act", "Data")
    //! runtextmacro LinkToStruct("Act", "Event")
    //! runtextmacro LinkToStruct("Act", "Id")

    //! runtextmacro CreateAnyFlagStateDefault("bonus", "Bonus", "false")
    //! runtextmacro CreateAnyStateDefault("bonusCaption", "BonusCaption", "string", "null")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyStateDefault("next", "Next", "thistype", "NULL")

    method CountLevels takes nothing returns integer
        return this.Data.Integer.Table.Count(LEVEL_KEY_ARRAY)
    endmethod

    method GetLevel takes integer index returns Level
        return this.Data.Integer.Table.Get(LEVEL_KEY_ARRAY, index)
    endmethod

    method AddLevel takes Level whichLevel returns nothing
        local integer index = this.Data.Integer.Table.Count(LEVEL_KEY_ARRAY) + 1

        call this.Data.Integer.Table.Add(LEVEL_KEY_ARRAY, whichLevel)

        call whichLevel.SetAct(this)
        call whichLevel.SetActIndex(index)
    endmethod

    method Ending_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local integer priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.ENDING_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call ACT.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Ending takes nothing returns nothing
        set thistype.CURRENT = NULL

        call this.Ending_TriggerEvents()

        if (Meteorite.GAME_OVER) then
            return
        endif

        set this = this.GetNext()

        if (this == NULL) then
            call Game.DebugMsg("Victory")
        else
            call this.Start()
        endif
    endmethod

    method Start_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local integer priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.START_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call ACT.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Start takes nothing returns nothing
        local integer level = 0

        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.CURRENT = this

        if (this == thistype.FIRST) then
            set level = 1
        elseif (this == thistype.SECOND) then
            set level = 2
        elseif (this == thistype.THIRD) then
            set level = 3
        elseif (this == thistype.FOURTH) then
            set level = 4
        elseif (this == thistype.FIFTH) then
            set level = 5
        elseif (this == thistype.SIXTH) then
            set level = 6
        endif

        if (level > 0) then
            call User.ANY.SetResearchBySelf('R000', level)
        endif

        call this.Start_TriggerEvents()
    endmethod

    static method Event_LevelEnding takes nothing returns nothing
        local Level whichLevel = LEVEL.Event.GetTrigger()

        local thistype this = whichLevel.GetAct()

        if (Meteorite.GAME_OVER) then
            return
        endif

        if (this.GetLevel(this.CountLevels()) == whichLevel) then
            call this.Ending()
        else
            call whichLevel.GetNext().Start()
        endif
    endmethod

    static method AdjustInfoPanel takes nothing returns nothing
        call Timer.GetExpired().Destroy()

        call Difficulty.DoAnnouncement()
    endmethod

    static method Event_DifficultySet takes nothing returns nothing
        call Meteorite.THIS_UNIT.Armor.IgnoreDamage.Relative.Set(0.)
        call Announcement.Create(1).Start()

        call Timer.Create().Start(15., false, function thistype.AdjustInfoPanel)

        call thistype.FIRST.Start()
    endmethod

    static method Event_Start takes nothing returns nothing
        local thistype this

        //call Event.Create(Difficulty.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call Event.Create(Level.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()

        call Meteorite.THIS_UNIT.Armor.IgnoreDamage.Relative.Set(1.)

        //Bonus
        set this = thistype.Create("")

        set thistype.BONUS = this
        call this.SetBonus(true)
        call this.SetBonusCaption("X")
        call this.AddLevel(Level.PENGUINS)

        //First
        set this = thistype.Create("Delightful disturbances")

        set thistype.FIRST = this
        call this.AddLevel(Level.DEERS)

        call this.AddLevel(Level.TROLLS)

        call this.AddLevel(Level.GNOLLS)

        call this.AddLevel(Level.MOONKINS)

        call this.AddLevel(Level.WOLVES)

        call this.AddLevel(Level.FURBOLG_ORACLE)

        //Second
        set this = thistype.Create("Dash into the fire")

        set thistype.SECOND = this
        call this.AddLevel(Level.SCOUTS)

        call this.AddLevel(Level.AXE_FIGHTERS)

        call this.AddLevel(Level.RAIDERS)

        call this.AddLevel(Level.CATAPULTS)

        call this.AddLevel(Level.ASSASSINS)

        call this.AddLevel(Level.LEADER)

        //Third
        set this = thistype.Create("Return of the elves")

        set thistype.THIRD = this

        //Fourth
        set this = thistype.Create("Desire beyond death")

        set thistype.FOURTH = this

        //Fifth
        set this = thistype.Create("The mourning mountain")

        set thistype.FIFTH = this

        //Sixth
        set this = thistype.Create("The dragon's flight, Frozen in time")

        set thistype.SIXTH = this

        //Start
        call thistype.BONUS.Start()
    endmethod

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetName(name)

        call this.AddToList()

        if (thistype.ALL_COUNT > ARRAY_EMPTY) then
            call thistype.ALL[thistype.ALL_COUNT - 1].SetNext(this)
        endif

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CURRENT = NULL
        set thistype.ENDING_EVENT_TYPE = EventType.Create()
        set thistype.START_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct