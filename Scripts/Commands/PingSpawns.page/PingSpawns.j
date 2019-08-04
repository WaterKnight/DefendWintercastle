//! runtextmacro BaseStruct("PingSpawns", "PING_SPAWNS")
    static constant string INPUT = "-pingSpawns"

    static boolean DEBUG_MSG

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Ping(thistype.DEBUG_MSG)
    endmethod

    eventMethod Event_Chat
        set thistype.DEBUG_MSG = String.ToBoolean(String.Word(params.String.GetChat(), 1))

        call Spawn.ALL_GROUP.Do(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct