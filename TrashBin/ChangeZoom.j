//! runtextmacro BaseStruct("ChangeZoom", "CHANGE_ZOOM")
    static constant string INPUT = "-zoom "
    static constant string INPUT2 = "-z "
    static constant real MAX = 2500.
    static constant real MIN = 1650.

    static method Event_Chat takes nothing returns nothing
        local string input = StringData.Event.GetChat()
        local real value
        local User whichPlayer = USER.Event.GetTrigger()

        set input = String.Word(input, 1)

        set value = String.ToReal(input)

        if (value < MIN) then
            set value = MIN
            call Game.DisplayText(whichPlayer, String.Color.GOLD + "Penguin perspective is not supported, continuing operation with a value of "+Real.ToString(MIN) + String.Color.RESET)
        elseif (value > MAX) then
            set value = MAX
            call Game.DisplayText(whichPlayer, String.Color.GOLD + "Entered value exceeds maximum, continuing operation with a value of "+Real.ToString(MAX) + String.Color.RESET)
        endif

        set Zoom.VALUE = value
        call Game.DisplayText(whichPlayer, String.Color.GOLD + "setting camera distance to "+Real.ToString(value) + String.Color.RESET)
    endmethod

    static method Init takes nothing returns nothing
        call StringData.Event.Add(INPUT, Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat))
        call StringData.Event.Add(INPUT2, Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat))
    endmethod
endstruct