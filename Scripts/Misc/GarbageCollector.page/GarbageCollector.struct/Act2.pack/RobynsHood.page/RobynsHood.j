//! runtextmacro BaseStruct("RobynsHood", "ROBYNS_HOOD")
    static constant real AGILITY_INCREMENT = 2.
    static constant real ARMOR_INCREMENT = 4.

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Hero.Agility.Bonus.Subtract(thistype.AGILITY_INCREMENT)
        call whichUnit.Armor.Bonus.Subtract(thistype.ARMOR_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Hero.Agility.Bonus.Add(thistype.AGILITY_INCREMENT)
        call whichUnit.Armor.Bonus.Add(thistype.ARMOR_INCREMENT)
    endmethod

    initMethod Init of Items_Act2
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct