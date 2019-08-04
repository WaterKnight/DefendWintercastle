//! runtextmacro BaseStruct("ClearSpawns", "CLEAR_SPAWNS")
    static constant string INPUT = "-clearSpawns"

    eventMethod Event_Chat
        call Spawn.RemoveAllUnits()
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct