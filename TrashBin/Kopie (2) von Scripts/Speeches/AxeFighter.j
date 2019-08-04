//! runtextmacro BaseStruct("AxeFighter", "AXE_FIGHTER")
    static Event ACQUIRES_TARGET_EVENT
    static UnitType SPEAKER

    static method Event_AcquiresTarget takes nothing returns nothing
        local Unit speakerUnit = UNIT.Event.GetTrigger()

        call thistype.SPEAKER.Event.Remove(ACQUIRES_TARGET_EVENT)

        call Game.DisplaySpeechFromUnit(speakerUnit, "Let's have some fun, everyone!", 2.)

        call Trigger.Sleep(2.)

        call Game.DisplaySpeechFromUnit(speakerUnit, "Loot the castle!", 1.)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ACQUIRES_TARGET_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.SPEECHES, function thistype.Event_AcquiresTarget)
        set thistype.SPEAKER = UnitType.AXE_FIGHTER

        call thistype.SPEAKER.Event.Add(ACQUIRES_TARGET_EVENT)
    endmethod
endstruct