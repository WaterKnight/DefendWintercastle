//! runtextmacro BaseStruct("Sebastian", "SEBASTIAN")
    static Unit THIS_UNIT

    eventMethod Event_Start
        set thistype.THIS_UNIT = Unit.GetFromSelf(gg_unit_uSeb_0040)
    endmethod

    initMethod Init of Units
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct