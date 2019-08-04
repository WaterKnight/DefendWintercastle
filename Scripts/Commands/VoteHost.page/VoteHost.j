//! runtextmacro Folder("VoteHost")
    //! runtextmacro Struct("Votes")
        static Event CHAT_EVENT
        static Dialog DUMMY_DIALOG
        static constant string INPUT = "-vote"
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKey("PLAYER_BUTTON_KEY")

        trigMethod ClickTrig
            local DialogButton dummyButton = DialogButton(NULL).Event.Native.GetClicked()
            local User dummyPlayer = User(NULL).Event.Native.GetTrigger()

            local User votedFor = dummyButton.Data.Integer.Get(KEY)

            call Game.DisplayTextTimed(User.ANY, dummyPlayer.GetColoredName() + " voted for " + votedFor.GetColoredName(), 5.)
        endmethod

        eventMethod Event_Chat
            local string chat = params.String.GetChat()

            if (chat != thistype.INPUT) then
                return
            endif

            call thistype.DUMMY_DIALOG.Display(params.User.GetTrigger(), true)
        endmethod

        static method Ending takes nothing returns nothing
            call StringData.Event.Remove(thistype.INPUT, thistype.CHAT_EVENT)
        endmethod

        static method Start takes nothing returns nothing
            call StringData.Event.Add(thistype.INPUT, thistype.CHAT_EVENT)
        endmethod

        eventMethod Event_Leave
            local User dummyPlayer = params.User.GetTrigger()

            local DialogButton dummyButton = dummyPlayer.Data.Integer.Get(PLAYER_BUTTON_KEY)

            call dummyPlayer.Data.Integer.Remove(PLAYER_BUTTON_KEY)

            call thistype.DUMMY_DIALOG.Buttons.Destroy(dummyButton)
        endmethod

        static method Init takes nothing returns nothing
            local DialogButton dummyButton
            local User dummyPlayer
            local integer iteration = User.PLAYING_HUMANS_COUNT

            set thistype.CHAT_EVENT = Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Chat)
            set thistype.DUMMY_DIALOG = Dialog.Create()

            call thistype.DUMMY_DIALOG.SetTitle("Who shall be host?")

            loop
                exitwhen (iteration < ARRAY_MIN)

                set dummyPlayer = User.PLAYING_HUMANS[iteration]

                set dummyButton = thistype.DUMMY_DIALOG.Buttons.Create(dummyPlayer.GetColoredName(), 0)

                call dummyButton.Data.Integer.Set(KEY, dummyPlayer)
                call dummyPlayer.Data.Integer.Set(PLAYER_BUTTON_KEY, dummyButton)

                set iteration = iteration - 1
            endloop

            call Event.Create(User.LEAVE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Leave).AddToStatics()

            call Trigger.CreateFromCode(function thistype.ClickTrig).RegisterEvent.Dialog(thistype.DUMMY_DIALOG)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("VoteHost", "VOTE_HOST")
    static boolean ACTIVE = false
    static Timer COOLDOWN_TIMER
    static boolean ON_COOLDOWN = false
    static constant string INPUT = "-votehost"

    //! runtextmacro LinkToStruct("VoteHost", "Votes")

    eventMethod Event_Chat
        local User whichPlayer = params.User.GetTrigger()

        if thistype.ACTIVE then
            call Game.DisplayTextTimed(whichPlayer, "A vote is already in process.", 5.)

            return
        elseif thistype.ON_COOLDOWN then
            call Game.DisplayTextTimed(whichPlayer, "The vote option is on cooldown for another " + Real.ToString(thistype.COOLDOWN_TIMER.GetRemaining()) + "seconds.", 5.)

            return
        endif

        set thistype.ACTIVE = true

        call thistype(NULL).Votes.Start()
    endmethod

    initMethod Init of Commands
        set thistype.COOLDOWN_TIMER = Timer.Create()
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct