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
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Level", "NULL")

        //! runtextmacro Event_Implement("Level")
    endstruct
endscope

//! runtextmacro BaseStruct("Level", "LEVEL")
    static integer BONUS_INDEX
    static integer CLASSIC_ENDING_INDEX
    static constant real DELAY = 10.
    static Timer DELAY_TIMER
    static EventType ENDING_EVENT_TYPE
    static EventType START_EVENT_TYPE

    static thistype CURRENT = NULL
    static thistype NEXT

    static thistype ASSASSINS
    static thistype AXE_FIGHTERS
    static thistype CATAPULTS
    static thistype DEERS
    static thistype FURBOLG_ORACLE
    static thistype GNOLLS
    static thistype LEADER
    static thistype MOONKINS
    static thistype PENGUINS
    static thistype RAIDERS
    static thistype SCOUTS
    static thistype TROLLS
    static thistype WOLVES

    //! runtextmacro LinkToStruct("Level", "Data")
    //! runtextmacro LinkToStruct("Level", "Event")
    //! runtextmacro LinkToStruct("Level", "Id")

    //! runtextmacro CreateAnyStateDefault("act", "Act", "Act", "NULL")
    //! runtextmacro CreateAnyStateDefault("actIndex", "ActIndex", "integer", "Memory.IntegerKeys.Table.EMPTY")
    //! runtextmacro CreateAnyFlagState("bonus", "Bonus")
    //! runtextmacro CreateAnyStateDefault("bonusCaption", "BonusCaption", "string", "null")
    //! runtextmacro CreateAnyStateDefault("icon", "Icon", "string", "null")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyStateDefault("next", "Next", "thistype", "NULL")

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

                call LEVEL.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = this.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call LEVEL.Event.SetTrigger(this)

                call this.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Ending takes nothing returns nothing
        set thistype.CURRENT = NULL

        call this.Ending_TriggerEvents()
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

                call LEVEL.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = this.Event.Count(thistype.START_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call LEVEL.Event.SetTrigger(this)

                call this.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Start takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.CURRENT = this

        call this.Start_TriggerEvents()
    endmethod

    static method StartByTimer takes nothing returns nothing
        if (Meteorite.GAME_OVER) then
            return
        endif

        call thistype.NEXT.Start()
    endmethod

    static method Event_ActStart takes nothing returns nothing
        if (thistype.CURRENT != NULL) then
            call thistype.CURRENT.Ending()
        endif

        set thistype.NEXT = ACT.Event.GetTrigger().GetLevel(Memory.IntegerKeys.Table.STARTED)

        call thistype.DELAY_TIMER.Start(thistype.DELAY, false, function thistype.StartByTimer)
    endmethod

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetIcon(icon)
        call this.SetName(name)

        call this.AddToList()

        if (thistype.ALL_COUNT > ARRAY_EMPTY) then
            call thistype.ALL[thistype.ALL_COUNT - 1].SetNext(this)
        endif

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        local thistype this

        set thistype.DELAY_TIMER = Timer.Create()
        set thistype.ENDING_EVENT_TYPE = EventType.Create()
        set thistype.START_EVENT_TYPE = EventType.Create()

        call Event.Create(Act.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActStart).AddToStatics()
        //call Event.Create(thistype.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()

        //Act1
            //Deers
            set this = thistype.Create("Deers")

            set thistype.DEERS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStag.blp")

            //Trolls
            set this = thistype.Create("Trolls")

            set thistype.TROLLS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIceTroll.blp")

            //Gnolls
            set this = thistype.Create("Gnolls")

            set thistype.GNOLLS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp")

            //Wolves
            set this = thistype.Create("Wolves")

            set thistype.MOONKINS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOwlBear.blp")

            //Moonkins
            set this = thistype.Create("Moonkins")

            set thistype.WOLVES = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")

            //BOSS - Furbolg Oracle
            set this = thistype.Create("Furbolg Oracle")

            set thistype.FURBOLG_ORACLE = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFurbolgTracker.blp")

        //Act2
            //Scouts
            set this = thistype.Create("Scouts")

            set thistype.SCOUTS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWyvernRider.blp")

            //Axe Fighters
            set this = thistype.Create("Axe Fighters")

            set thistype.AXE_FIGHTERS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGrunt.blp")

            //Raiders
            set this = thistype.Create("Raiders")

            set thistype.RAIDERS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRaider.blp")

            //Catapults
            set this = thistype.Create("Catapults")

            set thistype.CATAPULTS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCatapult.blp")

            //Assassins
            set this = thistype.Create("Assassins")

            set thistype.ASSASSINS = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHellScream.blp")

            //BOSS - Leader
            set this = thistype.Create("Leader")

            set thistype.LEADER = this
            call this.SetIcon("ReplaceableTextures\\CommandButtons\\BTNChaosWarlord.blp")

        set thistype.CLASSIC_ENDING_INDEX = thistype.ALL_COUNT

        //Bonus
            //Penguins
            set this = thistype.Create("Penguins")

            set thistype.PENGUINS = this
            call this.SetBonus(true)
            call this.SetBonusCaption("1")

        set thistype.BONUS_INDEX = thistype.ALL_COUNT
    endmethod
endstruct