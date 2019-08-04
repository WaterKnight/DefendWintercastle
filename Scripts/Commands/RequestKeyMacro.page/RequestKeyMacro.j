//! runtextmacro BaseStruct("RequestKeyMacro", "REQUEST_KEY_MACRO")
    static constant string INPUT = "-key"

    eventMethod Event_Chat
        local string input = params.String.GetChat()

        local string value = String.Word(input, 1)

        if (value == null) then
            call DebugEx("invalid syntax")

            return
        endif

        local integer valueI = String.ToInt(value)

        if (valueI == 0) then
            call DebugEx("invalid syntax")

            return
        endif

        local string result = Memory.GetKeyFromValue(valueI)

        if (result == null) then
            call DebugEx("no key found under " + Integer.ToString(valueI))

            return
        endif

        call DebugEx(result)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct