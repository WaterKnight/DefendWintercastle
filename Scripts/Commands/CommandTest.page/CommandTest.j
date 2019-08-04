//! runtextmacro BaseStruct("CommandTest", "COMMAND_TEST")
    static constant string INPUT = "-test"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        call Memory.IntegerKeys.D2.Table.AddInteger(-2147483376, 45, 53, 0, 186)

        local integer val = Memory.IntegerKeys.D2.Table.FetchFirstInteger(-2147483376, 47, 123, 0)

        call DebugEx("TEST: " + I2S(val))
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct