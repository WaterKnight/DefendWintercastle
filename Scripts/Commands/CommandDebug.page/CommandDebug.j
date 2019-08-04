//! runtextmacro BaseStruct("CommandDebug", "COMMAND_DEBUG")
    static constant string INPUT = "-debug"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        call DebugEx(String.Word(input, 1))
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct