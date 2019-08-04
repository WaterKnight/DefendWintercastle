//! runtextmacro BaseStruct("SetDmgTest", "SET_DMG_TEST")
    static constant string INPUT = "-dmgtest"

    static real VAL

    enumMethod Enum
        call BJUnit.Damage.Add(UNIT.Event.Native.GetEnum().self, thistype.VAL)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real val = String.ToReal(String.Word(input, 1))

        set thistype.VAL = val

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct