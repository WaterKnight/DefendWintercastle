//! runtextmacro BaseStruct("CommandSpell", "COMMAND_SPELL")
    static constant string INPUT = "-spell"
    static constant string INPUT_LIST_ALL = "-spellListAll"

    static integer LEVEL
    static Spell WHICH_SPELL

    eventMethod Event_ListAll_Chat
        local string input = params.String.GetChat()
        local integer iteration = Spell.ALL_COUNT
        local User whichPlayer = params.User.GetTrigger()

        call PreloadGenStart()

        loop
            exitwhen (iteration < ARRAY_MIN)

            call DebugEx(Spell.ALL[iteration].GetName())

            set iteration = iteration - 1
        endloop
    endmethod

    enumMethod Enum
        call UNIT.Event.Native.GetEnum().Abilities.AddWithLevel(thistype.WHICH_SPELL, thistype.LEVEL)
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local string spellWord = String.Word(input, 1)

        local Spell whichSpell = Spell.GetFromName(spellWord)
        local integer level = String.ToInt(String.Word(input, 2))

        if (whichSpell == NULL) then
            set whichSpell = String.ToIntWithInvalid(spellWord, ARRAY_EMPTY)

            if (whichSpell == ARRAY_EMPTY) then
                call DebugEx("invalid spell")

                return
            endif
        endif

        set thistype.LEVEL = level
        set thistype.WHICH_SPELL = whichSpell

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_LIST_ALL, function thistype.Event_ListAll_Chat)
    endmethod
endstruct