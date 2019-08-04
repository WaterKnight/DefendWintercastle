//! runtextmacro BaseStruct("Nullboard", "NULLBOARD")
    static constant real UPDATE_TIME = 0.25
    static integer TICK
    static Timer UPDATE_TIMER

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

    static integer CALLED_TRIGGERS_ROW
    static integer CALLED_TRIGGERS_PER_SECOND_ROW

    static Multiboard THIS_BOARD

    static method GetNewRow takes nothing returns integer
        return thistype.THIS_BOARD.GetNewRow()
    endmethod

    static method Update takes nothing returns nothing
        set thistype.TICK = thistype.TICK + 1

        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_ROW, thistype.VALUE_COLUMN, Integer.ToString(Trigger.RUN_COUNT))
        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_PER_SECOND_ROW, thistype.VALUE_COLUMN, Real.ToIntString(Trigger.RUN_COUNT / (thistype.TICK / (1 / thistype.UPDATE_TIME))))
    endmethod

    static method Event_AfterIntro takes nothing returns nothing
        if (USER.Event.GetTrigger().IsLocal()) then
            call thistype.THIS_BOARD.Show()
        endif

        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.TICK = 0
        set thistype.THIS_BOARD = Multiboard.Create()
        set thistype.UPDATE_TIMER = Timer.Create()
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

        call thistype.THIS_BOARD.SetTitle("Nullboard")

        set thistype.LABEL_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.VALUE_COLUMN = thistype.THIS_BOARD.GetNewColumn()

        set thistype.CALLED_TRIGGERS_ROW = thistype.GetNewRow()
        set thistype.CALLED_TRIGGERS_PER_SECOND_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Called triggers:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.SetValue(thistype.CALLED_TRIGGERS_PER_SECOND_ROW, thistype.LABEL_COLUMN, String.Color.Gradient("Per second:", String.Color.WHITE, String.Color.DWC))
        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, 0.1)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, 0.1)
    endmethod
endstruct