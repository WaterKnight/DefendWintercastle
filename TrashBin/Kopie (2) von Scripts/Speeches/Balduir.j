//! runtextmacro BaseStruct("Balduir", "BALDUIR")
    static Event ACQUIRES_TARGET_EVENT
    static UnitType SPEAKER

    static method Event_AcquiresTarget takes nothing returns nothing
        local Unit speakerUnit = UNIT.Event.GetTrigger()

        call thistype.SPEAKER.Event.Remove(ACQUIRES_TARGET_EVENT)

        call Game.DisplaySpeechFromUnit(speakerUnit, "Come before me, little worms!", 2.)

        call Trigger.Sleep(1.)

        call Game.DisplaySpeechFromUnit(speakerUnit, "I challenge you!", 0.75)

        call Trigger.Sleep(1.)

        call Game.DisplaySpeechFromUnit(speakerUnit, "The winner will be the one to survive.", 3.)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ACQUIRES_TARGET_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.SPEECHES, function thistype.Event_AcquiresTarget)
        set thistype.SPEAKER = UnitType.BALDUIR

        call thistype.SPEAKER.Event.Add(ACQUIRES_TARGET_EVENT)
    endmethod
endstruct