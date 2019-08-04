//! runtextmacro BaseStruct("CommandVertexColorUnit", "COMMAND_VERTEX_COLOR_UNIT")
    static constant string INPUT = "-vertexcolor"

    static real RED
    static real GREEN
    static real BLUE
    static real ALPHA

    static real DURATION

    enumMethod Enum
        local Unit target = UNIT.Event.Native.GetEnum()

        local real red = thistype.RED
        local real green = thistype.GREEN
        local real blue = thistype.BLUE
        local real alpha = thistype.ALPHA

        if (red == -1) then
            set red = target.VertexColor.Red.Get()
        endif
        if (green == -1) then
            set green = target.VertexColor.Green.Get()
        endif
        if (blue == -1) then
            set blue = target.VertexColor.Blue.Get()
        endif
        if (alpha == -1) then
            set alpha = target.VertexColor.Alpha.Get()
        endif

        call target.VertexColor.Timed.Add(red, green, blue, alpha, thistype.DURATION)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real red = String.ToRealWithInvalid(String.Word(input, 1), -1)
        local real green = String.ToRealWithInvalid(String.Word(input, 2), -1)
        local real blue = String.ToRealWithInvalid(String.Word(input, 3), -1)
        local real alpha = String.ToRealWithInvalid(String.Word(input, 4), -1)

        local real duration = String.ToReal(String.Word(input, 5))

        set thistype.RED = red
        set thistype.GREEN = green
        set thistype.BLUE = blue
        set thistype.ALPHA = alpha

        set thistype.DURATION = duration

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct