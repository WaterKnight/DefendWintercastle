//! runtextmacro BaseStruct("CommandExp", "COMMAND_EXP")
    static constant string INPUT = "-exp"

    static real VAL

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Exp.Set(thistype.VAL)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real val = String.ToReal(String.Word(input, 1))

        set thistype.VAL = val

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct