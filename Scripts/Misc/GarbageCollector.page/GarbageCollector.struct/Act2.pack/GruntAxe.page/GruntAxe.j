//! runtextmacro BaseStruct("GruntAxe", "GRUNT_AXE")
    static constant real CRITICAL_CHANCE_INCREMENT = 50.
    static constant real DAMAGE_INCREMENT = 8.

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Subtract(thistype.CRITICAL_CHANCE_INCREMENT)
        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Add(thistype.CRITICAL_CHANCE_INCREMENT)
        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
    endmethod

    initMethod Init of Items_Act2
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct