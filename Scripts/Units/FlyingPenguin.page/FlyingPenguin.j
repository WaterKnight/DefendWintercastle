//! runtextmacro BaseStruct("Pengu", "PENGU")
    eventMethod Event_Create
        call params.Unit.GetTrigger().Animation.Add(UNIT.Animation.SWIM)
    endmethod

    initMethod Init of Units
        call UnitType.FLYING_PENGUIN.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.UNIT_TYPES, function thistype.Event_Create))
    endmethod
endstruct