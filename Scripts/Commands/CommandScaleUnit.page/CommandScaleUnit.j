//! runtextmacro BaseStruct("CommandScaleUnit", "COMMAND_SCALE_UNIT")
    static constant string INPUT = "-scale"

    static real DURATION
    static real SCALE

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Scale.Timed.Add(thistype.SCALE, thistype.DURATION)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real scale = String.ToReal(String.Word(input, 1))
        local real duration = String.ToReal(String.Word(input, 2))

        set thistype.DURATION = duration
        set thistype.SCALE = scale

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct