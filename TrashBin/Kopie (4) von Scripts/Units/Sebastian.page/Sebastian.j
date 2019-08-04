//! runtextmacro BaseStruct("Sebastian", "SEBASTIAN")
    static Unit THIS_UNIT

    static method Event_Start takes nothing returns nothing
        set thistype.THIS_UNIT = Unit.CreateFromSelf(gg_unit_uSeb_0040)
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct