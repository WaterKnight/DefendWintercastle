//! runtextmacro BaseStruct("RabbitsFoot", "RABBITS_FOOT")
    static constant real CRITICAL_INCREMENT = 0.2
    static constant real EVASION_INCREMENT = 0.25

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Subtract(thistype.CRITICAL_INCREMENT)
        call whichUnit.EvasionChance.Bonus.Subtract(thistype.EVASION_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Add(thistype.CRITICAL_INCREMENT)
        call whichUnit.EvasionChance.Bonus.Add(thistype.EVASION_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct