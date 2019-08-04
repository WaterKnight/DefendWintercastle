//! runtextmacro BaseStruct("CameraSmoothing", "CAMERA_SMOOTHING")
    static constant string INPUT = "-smooth "
    static constant string INPUT2 = "-cs "
    static constant real MIN = 0.

    static method Event_Chat takes nothing returns nothing
        local string input = StringData.Event.GetChat()
        local real value
        local User whichPlayer = USER.Event.GetTrigger()

        set input = String.Word(input, 1)

        set value = String.ToReal(input)

        if (value < MIN) then
            set value = MIN
            call Game.DisplayText(whichPlayer, String.Color.GOLD + "Camera smoothing factor must not be negative, proceeding with "+Real.ToString(MIN) + String.Color.RESET)
        endif

        call Camera.SetSmoothing(whichPlayer, value)
    endmethod

    static method Event_AfterIntro takes nothing returns nothing
        call Camera.SetSmoothing(USER.Event.GetTrigger(), 2.)
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
        call StringData.Event.Add(INPUT, Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat))
        call StringData.Event.Add(INPUT2, Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat))
    endmethod
endstruct