//! runtextmacro BaseStruct("CommandBuff", "COMMAND_BUFF")
    static constant string INPUT = "-buff"
    static constant string INPUT_LIST_ALL = "-buffListAll"

    static integer LEVEL
    static Buff WHICH_BUFF
    static real DURATION

    eventMethod Event_ListAll_Chat
        local string input = params.String.GetChat()
        local integer iteration = Buff.ALL_COUNT
        local User whichPlayer = params.User.GetTrigger()

        call PreloadGenStart()

        loop
            exitwhen (iteration < ARRAY_MIN)

            call DebugEx(Buff.ALL[iteration].GetName())

            set iteration = iteration - 1
        endloop
    endmethod

    enumMethod Enum
        if (thistype.LEVEL == 0) then
            call UNIT.Event.Native.GetEnum().Buffs.Remove(thistype.WHICH_BUFF)

            return
        endif

        if (thistype.DURATION == 0) then
            call UNIT.Event.Native.GetEnum().Buffs.SetLevel(thistype.WHICH_BUFF, thistype.LEVEL, NULL)
        else
            call UNIT.Event.Native.GetEnum().Buffs.Timed.DoWithLevel(thistype.WHICH_BUFF, thistype.LEVEL, NULL, thistype.DURATION)
        endif
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local string buffWord = String.Word(input, 1)

        local Buff whichBuff = Buff.GetFromName(buffWord)
        local integer level = String.ToInt(String.Word(input, 2))
        local real duration = String.ToReal(String.Word(input, 3))

        if (whichBuff == NULL) then
            set whichBuff = String.ToIntWithInvalid(buffWord, ARRAY_EMPTY)

            if (whichBuff == ARRAY_EMPTY) then
                call DebugEx("invalid buff")

                return
            endif
        endif

        set thistype.LEVEL = level
        set thistype.WHICH_BUFF = whichBuff
        set thistype.DURATION = duration

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_LIST_ALL, function thistype.Event_ListAll_Chat)
    endmethod
endstruct