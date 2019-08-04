//! runtextmacro BaseStruct("CommandAutoCast", "COMMAND_AUTO_CAST")
    static constant string INPUT = "-autocast"

    static Spell WHICH_SPELL

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Abilities.AutoCast.Change(thistype.WHICH_SPELL)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local Spell whichSpell = Spell.GetFromName(String.Word(input, 1))

        if (whichSpell == NULL) then
            call DebugEx("invalid spell")

            return
        endif

        set thistype.WHICH_SPELL = whichSpell

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct