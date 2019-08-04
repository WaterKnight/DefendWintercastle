//! runtextmacro BaseStruct("MoveUnit", "MOVE_UNIT")
    static constant string INPUT = "-move"
    static real X
    static real Y

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Position.SetXY(thistype.X, thistype.Y)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real x = String.ToReal(String.Word(input, 1))
        local real y = String.ToReal(String.Word(input, 2))

        set thistype.X = x
        set thistype.Y = y

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct