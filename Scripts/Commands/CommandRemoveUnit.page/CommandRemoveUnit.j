//! runtextmacro BaseStruct("CommandRemoveUnit", "COMMAND_REMOVE_UNIT")
    static constant string INPUT = "-remove"

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Destroy()
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct