//! runtextmacro BaseStruct("RequestTimers", "REQUEST_TIMERS")
    static constant string INPUT = "-timers"

    eventMethod Event_Chat
        call Timer.RequestRunningList()
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct