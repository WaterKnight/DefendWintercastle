//! runtextmacro BaseStruct("Library", "LIBRARY")
    eventMethod Event_Create
        call params.Unit.GetTrigger().Color.Set(PLAYER_COLOR_LIGHT_BLUE)
    endmethod

    initMethod Init of Misc
        call thistype.SHOP.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.UNIT_TYPES, function thistype.Event_Create))
    endmethod
endstruct