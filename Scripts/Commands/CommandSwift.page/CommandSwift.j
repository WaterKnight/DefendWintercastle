//! runtextmacro BaseStruct("CommandSwift", "COMMAND_SWIFT")
    static constant string INPUT = "-swift"

    static real DURATION
    static integer LEVEL

    enumMethod Enum
        call Swiftness.Start(UNIT.Event.Native.GetEnum(), thistype.LEVEL)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local integer level = String.ToInt(String.Word(input, 1))
        local real duration = String.ToReal(String.Word(input, 2))

        set thistype.DURATION = duration
        set thistype.LEVEL = level

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct