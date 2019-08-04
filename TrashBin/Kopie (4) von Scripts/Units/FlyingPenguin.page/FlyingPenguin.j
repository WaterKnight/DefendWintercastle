//! runtextmacro BaseStruct("Pengu", "PENGU")
    static method Event_Create takes nothing returns nothing
        call UNIT.Event.GetTrigger().Animation.Add(UNIT.Animation.SWIM)
    endmethod

    static method Init takes nothing returns nothing
        call UnitType.FLYING_PENGUIN.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.UNIT_TYPES, function thistype.Event_Create))
    endmethod
endstruct