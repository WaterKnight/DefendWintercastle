//! runtextmacro Folder("LevelSet")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("LevelSet", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("LevelSet", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("LevelSet")
    endstruct

    //! runtextmacro Struct("Levels")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return LevelSet(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Level
            return LevelSet(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetLast takes nothing returns Level
            return LevelSet(this).Data.Integer.Table.GetLast(KEY_ARRAY)
        endmethod

        method Add takes Level val returns nothing
            call LevelSet(this).Data.Integer.Table.Add(KEY_ARRAY, val)
        endmethod

        method Shuffle takes nothing returns nothing
            call LevelSet(this).Data.Integer.Table.Shuffle(KEY_ARRAY)
        endmethod
    endstruct

    //! runtextmacro Struct("Query")
        static Event CHAT_EVENT
        static Event HOST_CHANGE_EVENT
        static constant string INPUT = "-rdy"

        static boolean ACTIVE = false
        static GameMessage MSG
        static LevelSet PARENT

        static method Ending takes nothing returns nothing
            if not thistype.ACTIVE then
                return
            endif

            set thistype.ACTIVE = false
            call thistype.MSG.Destroy()
            call StringData.Event.Remove(thistype.INPUT, thistype.CHAT_EVENT)

            call thistype.HOST_CHANGE_EVENT.RemoveFromStatics()
        endmethod

        eventMethod Event_Chat
            if (params.User.GetTrigger() != User.HOST) then
                return
            endif

            call thistype.Ending()

            call thistype.PARENT.Start()
        endmethod

        eventMethod Event_HostChange
            call thistype.MSG.Destroy()

            set thistype.MSG = GameMessage.Create(User.HOST.GetColoredName() + " type \"-rdy\" in order to start " + thistype.PARENT.GetName(), User.ANY)
        endmethod

        method Start takes nothing returns nothing
            if ACTIVE then
                call thistype.Ending()
            endif

            set thistype.ACTIVE = true
            set thistype.MSG = GameMessage.Create(User.HOST.GetColoredName() + " type \"-rdy\" in order to start " + LevelSet(this).GetName(), User.ANY)
            set thistype.PARENT = this
            call StringData.Event.Add(thistype.INPUT, thistype.CHAT_EVENT)

            call thistype.HOST_CHANGE_EVENT.AddToStatics()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.CHAT_EVENT = Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat)
            set thistype.HOST_CHANGE_EVENT = Event.Create(USER.HostAppointment.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HostChange)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("LevelSet", "LEVEL_SET")
    static thistype ACT1_PART1
    static thistype ACT1_PART2
    static thistype ACT1_PART3
    static thistype ACT1_BOSS_PART
    static thistype ACT2_PART1
    static thistype ACT2_PART2
    static thistype ACT2_PART3
    static thistype ACT2_BOSS_PART
    static thistype BONUS_ACT_PART1

    static thistype CURRENT = NULL

    //! runtextmacro LinkToStruct("LevelSet", "Data")
    //! runtextmacro LinkToStruct("LevelSet", "Id")
    //! runtextmacro LinkToStruct("LevelSet", "Levels")
    //! runtextmacro LinkToStruct("LevelSet", "Query")

    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyState("next", "Next", "thistype")

    method Ending takes nothing returns nothing
        if (this == NULL) then
            return
        endif

        set thistype.CURRENT = NULL

        call thistype(NULL).Query.Ending()

        if (Level.CURRENT != NULL) then
            call Level.CURRENT.Ending()
        endif
    endmethod

    method Start takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.CURRENT = this

        call this.Levels.Get(Memory.IntegerKeys.Table.STARTED).Start()
    endmethod

    static method QueryNext takes nothing returns nothing
        local thistype this = thistype.CURRENT

        if (this == NULL) then
            return
        endif

        call this.Ending()

        set this = this.GetNext()

        if (this == NULL) then
            call Act.StartNext()
        else
            call this.Query.Start()
        endif
    endmethod

    eventMethod Event_GameOver
        call thistype(NULL).Query.Ending()
    endmethod

    eventMethod Event_LevelEnding
        local Level whichLevel = params.Level.GetTrigger()

        local thistype this = thistype.CURRENT

        if (whichLevel == this.Levels.Get(this.Levels.Count())) then
            call this.QueryNext()
        else
            call whichLevel.GetNext().Start()
        endif
    endmethod

    eventMethod Event_ActStart
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        call params.Act.GetTrigger().LevelSets.Get(Memory.IntegerKeys.Table.STARTED).Query.Start()
    endmethod

    static method Create takes string name, thistype prev returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        call this.SetName(name)
        call this.SetNext(NULL)

        call prev.SetNext(this)

        return this
    endmethod

    static method AddLevels takes nothing returns nothing
        call thistype.ACT1_PART1.Levels.Add(Level.DEERS)
        call thistype.ACT1_PART1.Levels.Add(Level.TROLLS)
        call thistype.ACT1_PART1.Levels.Add(Level.GNOLLS)

        call thistype.ACT1_PART1.Levels.Shuffle()

        call thistype.ACT1_PART2.Levels.Add(Level.WOLVES)
        call thistype.ACT1_PART2.Levels.Add(Level.MOONKINS)
        call thistype.ACT1_PART2.Levels.Add(Level.SNOW_FALCONS)

        call thistype.ACT1_PART2.Levels.Shuffle()

        call thistype.ACT1_PART3.Levels.Add(Level.KOBOLDS)
        call thistype.ACT1_PART3.Levels.Add(Level.TREANTS)

        call thistype.ACT1_PART3.Levels.Shuffle()

        call thistype.ACT1_BOSS_PART.Levels.Add(Level.FURBOLG_ORACLE)

        call thistype.ACT2_PART1.Levels.Add(Level.SCOUTS)
        call thistype.ACT2_PART1.Levels.Add(Level.AXE_FIGHTERS)
        call thistype.ACT2_PART1.Levels.Add(Level.RAIDERS)

        call thistype.ACT1_PART1.Levels.Shuffle()

        call thistype.ACT2_PART2.Levels.Add(Level.CATAPULTS)
        call thistype.ACT2_PART2.Levels.Add(Level.ASSASSINS)

        call thistype.ACT1_PART2.Levels.Shuffle()

        call thistype.ACT2_BOSS_PART.Levels.Add(Level.LEADER)

        call thistype.BONUS_ACT_PART1.Levels.Add(Level.PENGUINS)
    endmethod

    static method InitObjs takes nothing returns nothing
        set thistype.ACT1_PART1 = thistype.Create("Act 1 - Part 1", NULL)
        set thistype.ACT1_PART2 = thistype.Create("Act 1 - Part 2", thistype.ACT1_PART1)
        set thistype.ACT1_PART3 = thistype.Create("Act 1 - Part 3", thistype.ACT1_PART2)
        set thistype.ACT1_BOSS_PART = thistype.Create("Act 1 - Boss", thistype.ACT1_PART3)

        set thistype.ACT2_PART1 = thistype.Create("Act 2 - Part 1", NULL)
        set thistype.ACT2_PART2 = thistype.Create("Act 2 - Part 2", thistype.ACT2_PART1)
        set thistype.ACT2_PART3 = thistype.Create("Act 2 - Part 3", thistype.ACT2_PART2)
        set thistype.ACT2_BOSS_PART = thistype.Create("Act 2 - Boss", thistype.ACT2_PART3)

        set thistype.BONUS_ACT_PART1 = thistype.Create("Bonus", NULL)

        call thistype.AddLevels()
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(Level.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()
        call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()

        call thistype.InitObjs()

        call thistype(NULL).Query.Init()
    endmethod
endstruct

//! runtextmacro Folder("Level")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Level", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Level", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("Level", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Level")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Level")
    endstruct
endscope

//! runtextmacro BaseStruct("Level", "LEVEL")
    static integer BONUS_INDEX
    static integer CLASSIC_ENDING_INDEX
    static EventType ENDING_EVENT_TYPE
    //! runtextmacro GetKey("PARENT_KEY")
    static EventType START_EVENT_TYPE

    static thistype ASSASSINS
    static thistype AXE_FIGHTERS
    static thistype CATAPULTS
    static thistype DEERS
    static thistype FURBOLG_ORACLE
    static thistype GNOLLS
    static thistype KOBOLDS
    static thistype LEADER
    static thistype MOONKINS
    static thistype PENGUINS
    static thistype RAIDERS
    static thistype SCOUTS
    static thistype SNOW_FALCONS
    static thistype TREANTS
    static thistype TROLLS
    static thistype WOLVES

	static thistype CURRENT = NULL

    //! runtextmacro LinkToStruct("Level", "Data")
    //! runtextmacro LinkToStruct("Level", "Event")
    //! runtextmacro LinkToStruct("Level", "Id")

    //! runtextmacro CreateAnyStateDefault("act", "Act", "Act", "NULL")
    //! runtextmacro CreateAnyStateDefault("actIndex", "ActIndex", "integer", "DataTable(NULL).IntegerKeys.Table.EMPTY")
    //! runtextmacro CreateAnyFlagState("bonus", "Bonus")
    //! runtextmacro CreateAnyStateDefault("bonusCaption", "BonusCaption", "string", "null")
    //! runtextmacro CreateAnyStateDefault("icon", "Icon", "string", "null")
    //! runtextmacro CreateAnyState("whichSet", "LevelSet", "LevelSet")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyStateDefault("next", "Next", "thistype", "NULL")

    static method InitNexts takes nothing returns nothing
        local integer iteration = ARRAY_MIN

        loop
            exitwhen (iteration > Act.ALL_COUNT)

            local thistype last = NULL
            local Act whichAct = Act.ALL[iteration]

            local integer iteration2 = whichAct.LevelSets.Count()

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                local LevelSet whichSet = whichAct.LevelSets.Get(iteration2)

                local integer iteration3 = whichSet.Levels.Count()

                loop
                    exitwhen (iteration3 < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = whichSet.Levels.Get(iteration3)

                    call this.SetLevelSet(whichSet)
                    call this.SetNext(last)

                    set last = this

                    set iteration3 = iteration3 - 1
                endloop

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration + 1
        endloop
    endmethod

    method Ending_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.Level.SetTrigger(this)

		local EventResponse levelParams = EventResponse.Create(this.Id.Get())

        call levelParams.Level.SetTrigger(this)

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

            set iteration2 = this.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(levelParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call levelParams.Destroy()
        call params.Destroy()
    endmethod

    method Ending takes nothing returns nothing
        set thistype.CURRENT = NULL

        call this.Ending_TriggerEvents()
    endmethod

    method Start_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)
        
        call params.Level.SetTrigger(this)

        local EventResponse levelParams = EventResponse.Create(this.Id.Get())

        call levelParams.Level.SetTrigger(this)

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

            set iteration2 = this.Event.Count(thistype.START_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(levelParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call levelParams.Destroy()
        call params.Destroy()
    endmethod

    method Start takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.CURRENT = this

        if (this.GetNext() == NULL) then
            call Game.DisplayTextTimed(User.ANY, "New level begins: " + String.Color.Do(this.GetName(), String.Color.GOLD), 15.)
        else
            call Game.DisplayTextTimed(User.ANY, "New level begins: " + String.Color.Do(this.GetName(), String.Color.GOLD) + ", next is " + String.Color.Do(this.GetNext().GetName(), String.Color.GOLD), 15.)
        endif

        call this.Start_TriggerEvents()
    endmethod

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetIcon(icon)
        call this.SetLevelSet(NULL)
        call this.SetName(name)
        call this.SetNext(NULL)

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init_Penguins takes nothing returns nothing
        local thistype this = thistype.Create("Penguins")

        set thistype.PENGUINS = this
        call this.SetBonus(true)
        call this.SetBonusCaption("1")
    endmethod

    static method Init_Leader takes nothing returns nothing
        local thistype this = thistype.Create("Leader")

        set thistype.LEADER = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNChaosWarlord.blp")
    endmethod

    static method Init_Assassins takes nothing returns nothing
        local thistype this = thistype.Create("Assassins")

        set thistype.ASSASSINS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHellScream.blp")
    endmethod

    static method Init_Catapults takes nothing returns nothing
        local thistype this = thistype.Create("Catapults")

        set thistype.CATAPULTS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCatapult.blp")
    endmethod

    static method Init_Raiders takes nothing returns nothing
        local thistype this = thistype.Create("Raiders")

        set thistype.RAIDERS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRaider.blp")
    endmethod

    static method Init_AxeFighters takes nothing returns nothing
        local thistype this = thistype.Create("Axe Fighters")

        set thistype.AXE_FIGHTERS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGrunt.blp")
    endmethod

    static method Init_Scouts takes nothing returns nothing
        local thistype this = thistype.Create("Scouts")

        set thistype.SCOUTS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWyvernRider.blp")
    endmethod

    static method Init_FurbolgOracle takes nothing returns nothing
        local thistype this = thistype.Create("Furbolg Oracle")

        set thistype.FURBOLG_ORACLE = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFurbolgTracker.blp")
    endmethod

    static method Init_Treants takes nothing returns nothing
        local thistype this = thistype.Create("Treants")

        set thistype.TREANTS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCorruptedEnt.blp")
    endmethod

    static method Init_Kobolds takes nothing returns nothing
        local thistype this = thistype.Create("Kobolds")

        set thistype.KOBOLDS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNKobold.blp")
    endmethod

    static method Init_SnowFalcons takes nothing returns nothing
        local thistype this = thistype.Create("SnowFalcons")

        set thistype.SNOW_FALCONS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWarEagle.blp")
    endmethod

    static method Init_Moonkins takes nothing returns nothing
        local thistype this = thistype.Create("Moonkins")

        set thistype.MOONKINS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOwlBear.blp")
    endmethod

    static method Init_Wolves takes nothing returns nothing
        local thistype this = thistype.Create("Wolves")

        set thistype.WOLVES = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
    endmethod

    static method Init_Gnolls takes nothing returns nothing
        local thistype this = thistype.Create("Gnolls")

        set thistype.GNOLLS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp")
    endmethod

    static method Init_Trolls takes nothing returns nothing
        local thistype this = thistype.Create("Trolls")

        set thistype.TROLLS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIceTroll.blp")
    endmethod

    static method Init_Deers takes nothing returns nothing
        local thistype this = thistype.Create("Deers")

        set thistype.DEERS = this
        call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStag.blp")
    endmethod

    static method InitObjs takes nothing returns nothing
        call thistype.Init_Deers()
        call thistype.Init_Trolls()
        call thistype.Init_Gnolls()
        call thistype.Init_Wolves()
        call thistype.Init_Moonkins()
        call thistype.Init_SnowFalcons()
        call thistype.Init_Kobolds()
        call thistype.Init_Treants()
        call thistype.Init_FurbolgOracle()
        call thistype.Init_Scouts()
        call thistype.Init_AxeFighters()
        call thistype.Init_Raiders()
        call thistype.Init_Catapults()
        call thistype.Init_Assassins()
        call thistype.Init_Leader()

        set thistype.CLASSIC_ENDING_INDEX = thistype.ALL_COUNT

        call thistype.Init_Penguins()

        set thistype.BONUS_INDEX = thistype.ALL_COUNT
    endmethod

    initMethod Init of Misc_Level
        set thistype.ENDING_EVENT_TYPE = EventType.Create()
        set thistype.START_EVENT_TYPE = EventType.Create()

        //call Event.Create(thistype.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()

        call thistype.InitObjs()

        call LevelSet.Init()
    endmethod
endstruct