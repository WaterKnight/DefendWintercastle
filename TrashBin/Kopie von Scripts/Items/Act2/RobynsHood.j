//! runtextmacro BaseStruct("RobynsHood", "ROBYNS_HOOD")
    static constant real AGILITY_INCREMENT = 2.
    static constant real ARMOR_INCREMENT = 4.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Hero.Agility.Bonus.Subtract(thistype.AGILITY_INCREMENT)
        call whichUnit.Armor.Bonus.Subtract(thistype.ARMOR_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Hero.Agility.Bonus.Add(thistype.AGILITY_INCREMENT)
        call whichUnit.Armor.Bonus.Add(thistype.ARMOR_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call ItemType.ROBYNS_HOOD.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call ItemType.ROBYNS_HOOD.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct