//! runtextmacro Folder("Nullboard")
    //! runtextmacro Struct("QuestLog")
        static quest DUMMY_QUEST
        static string DUMMY_STRING
        static constant integer MAX_LINES = 100
        //! runtextmacro CreateQueue("QUEUED")

        string text

        method Destroy takes nothing returns nothing
            call this.deallocate()
        endmethod

        static method Create takes string text returns nothing
            local thistype this = thistype.allocate()

            if (thistype.QUEUED_Count() >= thistype.MAX_LINES) then
                call thistype.QUEUED_FetchFirst().Destroy()
            endif

            set this.text = text

            call thistype.QUEUED_Add(this)

            set thistype.DUMMY_STRING = text

            loop
                set this = thistype.QUEUED_GetPrev(this)
                exitwhen (this == NULL)

                set thistype.DUMMY_STRING = thistype.DUMMY_STRING + Char.BREAK + this.text
            endloop

            call QuestSetDescription(thistype.DUMMY_QUEST, thistype.DUMMY_STRING)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_QUEST = CreateQuest()

            call QuestSetIconPath(thistype.DUMMY_QUEST, "ReplaceableTextures\\CommandButtons\\BTNPeon.blp")
            call QuestSetTitle(thistype.DUMMY_QUEST, "DebugLog")
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Nullboard", "NULLBOARD")
    static constant real UPDATE_TIME = 0.5
    static Timer UPDATE_TIMER

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

    static integer CALLED_TRIGGERS_ROW
    static integer CALLED_TRIGGERS_PER_SECOND_ROW
    static integer OBJS_ROW
    static integer NATIVE_OBJS_ROW

    static Multiboard THIS_BOARD

	static integer TICK

    //! runtextmacro LinkToStruct("Nullboard", "QuestLog")

    static method GetNewRow takes nothing returns integer
        return thistype.THIS_BOARD.GetNewRow()
    endmethod

    timerMethod Update
        set thistype.TICK = thistype.TICK + 1

        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_ROW, thistype.VALUE_COLUMN, Integer.ToString(Trigger.RUN_COUNT))
        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_PER_SECOND_ROW, thistype.VALUE_COLUMN, Real.ToIntString(Trigger.RUN_COUNT / (thistype.TICK / (1 / thistype.UPDATE_TIME))))
        call thistype.THIS_BOARD.SetValue(thistype.OBJS_ROW, thistype.VALUE_COLUMN, Integer.ToString(Basic.ALLOCATED_OBJS_COUNT))
        call thistype.THIS_BOARD.SetValue(thistype.NATIVE_OBJS_ROW, thistype.VALUE_COLUMN, Integer.ToString(Basic.NATIVE_OBJS_COUNT))
    endmethod

    eventMethod Event_AfterIntro
        call thistype.THIS_BOARD.Show(params.User.GetTrigger())

        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static boolean LOG_INITED = false
    static string array LOG_LINES
    static constant integer LOG_LINES_MAX = 8
    static integer array LOG_ROWS

    static method WriteLogLine takes string val returns nothing
        set thistype.LOG_LINES[ARRAY_MIN + thistype.LOG_LINES_MAX] = val

		local integer iteration = 0

        loop
            exitwhen (iteration > thistype.LOG_LINES_MAX - 1)

            local integer index = ARRAY_MIN + iteration

            set thistype.LOG_LINES[index] = thistype.LOG_LINES[index + 1]

            call thistype.THIS_BOARD.SetValue(thistype.LOG_ROWS[index], thistype.VALUE_COLUMN, thistype.LOG_LINES[index])

            set iteration = iteration + 1
        endloop

        call thistype(NULL).QuestLog.Create(val)
    endmethod

    static method InitLog takes nothing returns nothing
        local integer newRow = thistype.GetNewRow()

        set newRow = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(newRow, thistype.LABEL_COLUMN, String.Color.Gradient("Log:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.SetWidth(newRow, thistype.LABEL_COLUMN, 0.2)

		local integer iteration = 0

        loop
            exitwhen (iteration > thistype.LOG_LINES_MAX - 1)

            local integer index = ARRAY_MIN + iteration

            set thistype.LOG_LINES[index] = ""

            set newRow = thistype.GetNewRow()

            call thistype.THIS_BOARD.SetWidth(newRow, thistype.LABEL_COLUMN, 0.000001)
            call thistype.THIS_BOARD.SetWidth(newRow, thistype.VALUE_COLUMN, 0.199999)

            set thistype.LOG_ROWS[index] = newRow

            set iteration = iteration + 1
        endloop

        set thistype.LOG_INITED = true
    endmethod

    initMethod Init of Misc_2
        set thistype.THIS_BOARD = Multiboard.Create()
        set thistype.UPDATE_TIMER = Timer.Create()
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

        call thistype.THIS_BOARD.SetTitle("Nullboard")

        set thistype.LABEL_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.VALUE_COLUMN = thistype.THIS_BOARD.GetNewColumn()

        set thistype.CALLED_TRIGGERS_ROW = thistype.GetNewRow()
        set thistype.CALLED_TRIGGERS_PER_SECOND_ROW = thistype.GetNewRow()
        set thistype.OBJS_ROW = thistype.GetNewRow()
        set thistype.NATIVE_OBJS_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Called triggers:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_PER_SECOND_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Per second:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.SetValue(thistype.OBJS_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Objs count:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.SetValue(thistype.NATIVE_OBJS_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Native objs count:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, 0.1)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, 0.1)

        call thistype.InitLog()

        call thistype(NULL).QuestLog.Init()

		set thistype.TICK = 0
    endmethod
endstruct