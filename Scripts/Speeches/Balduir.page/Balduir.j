//! runtextmacro BaseStruct("Balduir", "BALDUIR")
    static Event ACQUIRES_TARGET_EVENT
    static UnitType SPEAKER

    eventMethod Event_AcquiresTarget
        local Unit speakerUnit = params.Unit.GetTrigger()

        call thistype.SPEAKER.Event.Remove(ACQUIRES_TARGET_EVENT)

        call Game.DisplaySpeechFromUnit(speakerUnit, "Crawl before me, little worms!", 2.)

        call Trigger.Sleep(1.)

        call Game.DisplaySpeechFromUnit(speakerUnit, "I challenge you!", 0.75)

        call Trigger.Sleep(1.)

        call Game.DisplaySpeechFromUnit(speakerUnit, "Only the winner shall be the one to survive.", 3.)
    endmethod

    initMethod Init of Speeches
        set thistype.ACQUIRES_TARGET_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.SPEECHES, function thistype.Event_AcquiresTarget)
        set thistype.SPEAKER = UnitType.BALDUIR

        call thistype.SPEAKER.Event.Add(ACQUIRES_TARGET_EVENT)
    endmethod
endstruct