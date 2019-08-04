//! runtextmacro BaseStruct("RequestEvent", "REQUEST_EVENT")
    static constant string INPUT = "-event"

    eventMethod Event_Chat
        local string input = params.String.GetChat()

        local integer id = String.ToInt(String.Word(input, 1))

        call DebugEx(Event(id).GetName())
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct