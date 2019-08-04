//! runtextmacro BaseStruct("AfterIntro", "AFTER_INTRO")
    static EventType DUMMY_EVENT_TYPE
    static EventType FOR_PLAYER_EVENT_TYPE
    static Force FOR_PLAYER_FORCE

    static method ForPlayer_TriggerEvents takes User whichPlayer returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.User.SetTrigger(whichPlayer)

        call thistype.FOR_PLAYER_FORCE.RemovePlayer(whichPlayer)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.FOR_PLAYER_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.FOR_PLAYER_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    static method StartForPlayer takes User whichPlayer returns nothing
        call thistype.ForPlayer_TriggerEvents(whichPlayer)
    endmethod

    static method TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        loop
            local User whichUser = thistype.FOR_PLAYER_FORCE.GetFirst()
            exitwhen (whichUser == NULL)

            call thistype.ForPlayer_TriggerEvents(whichUser)
        endloop

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    static method Start takes nothing returns nothing
        call thistype.TriggerEvents()
    endmethod

    initMethod Init of Misc
        local integer iteration = User.PLAYING_HUMANS_COUNT

        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        set thistype.FOR_PLAYER_EVENT_TYPE = EventType.Create()
        set thistype.FOR_PLAYER_FORCE = Force.Create()

        loop
            exitwhen (iteration < ARRAY_MIN)

            call thistype.FOR_PLAYER_FORCE.AddPlayer(User.PLAYING_HUMANS[iteration])

            set iteration = iteration - 1
        endloop
    endmethod
endstruct