//! runtextmacro BaseStruct("CharacterSpeech", "CHARACTER_SPEECH")
    static constant string INPUT = "!"

    static method Event_Chat takes nothing returns nothing
        local string input = StringData.Event.GetChat()
        local User whichPlayer = USER.Event.GetTrigger()

        local Unit whichUnit = whichPlayer.Hero.Get()

        set input = String.SubRight(input, String.MIN_LENGTH)

        if (whichUnit != NULL) then
            call whichUnit.AddRisingTextTag(whichPlayer.GetColoredName() + ": " + input, TextTag.STANDARD_SIZE, 100., 2., 3. + 0.1 * String.Length(input), TextTag.GetFreeId()).Position.SetCentered()
        endif
    endmethod

    static method Init takes nothing returns nothing
        call StringData.Event.Add(thistype.INPUT, Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat))
    endmethod
endstruct