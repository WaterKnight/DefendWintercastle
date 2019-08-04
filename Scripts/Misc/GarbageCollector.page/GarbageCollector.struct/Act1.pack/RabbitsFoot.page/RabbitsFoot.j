//! runtextmacro BaseStruct("RabbitsFoot", "RABBITS_FOOT")
    static constant real CRITICAL_INCREMENT = 0.2
    static constant real EVASION_INCREMENT = 0.25

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()
call DebugEx("drop")
        call whichUnit.CriticalChance.Bonus.Subtract(thistype.CRITICAL_INCREMENT)
        call whichUnit.EvasionChance.Bonus.Subtract(thistype.EVASION_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()
call DebugEx("pickup")
        call whichUnit.CriticalChance.Bonus.Add(thistype.CRITICAL_INCREMENT)
        call whichUnit.EvasionChance.Bonus.Add(thistype.EVASION_INCREMENT)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct