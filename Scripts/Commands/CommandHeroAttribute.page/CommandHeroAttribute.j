//! runtextmacro BaseStruct("CommandHeroAttribute", "COMMAND_HERO_ATTRIBUTE")
    static constant string INPUT_AGI = "-agi"
    static constant string INPUT_INT = "-int"
    static constant string INPUT_STR = "-str"

    static string ATTR
    static real VAL

    enumMethod Enum
        if (thistype.ATTR == "-agi") then
            call UNIT.Event.Native.GetEnum().Agility.Base.Add(thistype.VAL)
        elseif (thistype.ATTR == "-int") then
            call UNIT.Event.Native.GetEnum().Intelligence.Base.Add(thistype.VAL)
        elseif (thistype.ATTR == "-str") then
            call UNIT.Event.Native.GetEnum().Strength.Base.Add(thistype.VAL)
        else
            call DebugEx("unrecognized")
        endif
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local string attr = params.String.GetMatch()

        local real val = String.ToReal(String.Word(input, 1))

        set thistype.ATTR = attr
        set thistype.VAL = val

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT_AGI, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_INT, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_STR, function thistype.Event_Chat)
    endmethod
endstruct