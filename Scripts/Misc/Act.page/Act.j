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
        //! runtextmacro Event_Implement("Act")
    endstruct

    //! runtextmacro Struct("LevelSets")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return Level(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns LevelSet
            return Level(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes LevelSet val returns nothing
            call Level(this).Data.Integer.Table.Add(KEY_ARRAY, val)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Act", "ACT")
    static EventType ENDING_EVENT_TYPE
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
    //! runtextmacro LinkToStruct("Act", "LevelSets")

    //! runtextmacro CreateAnyFlagStateDefault("bonus", "Bonus", "false")
    //! runtextmacro CreateAnyStateDefault("bonusCaption", "BonusCaption", "string", "null")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyStateDefault("next", "Next", "thistype", "NULL")

    method Ending_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Act.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.ENDING_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Ending takes nothing returns nothing
        set thistype.CURRENT = NULL

        call this.Ending_TriggerEvents()

        if Meteorite.GAME_OVER then
            return
        endif
    endmethod

    static method StartNext takes nothing returns nothing
        local thistype this = thistype.CURRENT

        if (this == NULL) then
            return
        endif

        call this.Ending()

        set this = this.GetNext()

        if (this == NULL) then
            call Game.DebugMsg("Victory")
        else
            call this.Start()
        endif
    endmethod

    method Start_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Act.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.START_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Start takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.CURRENT = this

		local integer level = 0

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

        call Game.DisplayTextTimed(User.ANY, "New Chapter begins: " + String.Color.Do(this.GetName(), String.Color.GOLD), 15.)
        if (level > 0) then
            call User.ANY.SetResearchBySelf('R000', level)
        endif

        call this.Start_TriggerEvents()
    endmethod

    static method AdjustInfoPanel takes nothing returns nothing
        call Timer.GetExpired().Destroy()

        call Difficulty.DoAnnouncement()
    endmethod

    static method Event_DifficultySet takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        call Meteorite.THIS_UNIT.Armor.IgnoreDamage.Relative.Set(0.)
        call Announcement.Create(1).Start()

        call Timer.Create().Start(5., false, function thistype.AdjustInfoPanel)

        call thistype.FIRST.Start()
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

    eventMethod Event_Start
        call Event.Create(Act.START_EVENT_TYPE, EventPriority.MISC, function LevelSet.Event_ActStart).AddToStatics()

        call thistype.BONUS.Start()
    endmethod

    static method InitObjs takes nothing returns nothing
        local thistype this

        //Bonus
        set this = thistype.Create("Penguin Prelude")

        set thistype.BONUS = this
        call this.SetBonus(true)
        call this.SetBonusCaption("X")
        call this.LevelSets.Add(LevelSet.BONUS_ACT_PART1)

        //First
        set this = thistype.Create("Delightful disturbances")

        set thistype.FIRST = this
        call this.LevelSets.Add(LevelSet.ACT1_PART1)
        call this.LevelSets.Add(LevelSet.ACT1_PART2)
        call this.LevelSets.Add(LevelSet.ACT1_PART3)
        call this.LevelSets.Add(LevelSet.ACT1_BOSS_PART)

        //Second
        set this = thistype.Create("Dash into the fire")

        set thistype.SECOND = this
        call this.LevelSets.Add(LevelSet.ACT2_PART1)
        call this.LevelSets.Add(LevelSet.ACT2_PART2)
        call this.LevelSets.Add(LevelSet.ACT2_PART3)
        call this.LevelSets.Add(LevelSet.ACT2_BOSS_PART)

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
    endmethod

    initMethod Init of Misc_3
        set thistype.CURRENT = NULL
        set thistype.ENDING_EVENT_TYPE = EventType.Create()
        set thistype.START_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        //call Event.Create(Difficulty.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

        call Meteorite.THIS_UNIT.Armor.IgnoreDamage.Relative.Set(1.)

        call thistype.InitObjs()

        call Level.InitNexts()
    endmethod
endstruct