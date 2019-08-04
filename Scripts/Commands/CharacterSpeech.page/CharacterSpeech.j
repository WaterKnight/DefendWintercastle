//! runtextmacro BaseStruct("CharacterSpeech", "CHARACTER_SPEECH")
    static constant string INPUT = "!"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local Unit whichUnit = whichPlayer.Hero.Get()

        set input = String.SubRight(input, String.MIN_LENGTH)

        if (whichUnit != NULL) then
            call whichUnit.AddRisingTextTag(whichPlayer.GetColoredName() + ": " + input, TextTag.STANDARD_SIZE, 100., 2., 3. + 0.1 * String.Length(input), TextTag.GetFreeId()).Position.SetCentered()
        endif
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct