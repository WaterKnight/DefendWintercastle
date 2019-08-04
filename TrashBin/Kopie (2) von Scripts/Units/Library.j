//! runtextmacro BaseStruct("Library", "LIBRARY")
    static method Event_Create takes nothing returns nothing
        call UNIT.Event.GetTrigger().Color.Set(PLAYER_COLOR_LIGHT_BLUE)
    endmethod

    static method Init takes nothing returns nothing
        call UnitType.LIBRARY.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.UNIT_TYPES, function thistype.Event_Create))
    endmethod
endstruct