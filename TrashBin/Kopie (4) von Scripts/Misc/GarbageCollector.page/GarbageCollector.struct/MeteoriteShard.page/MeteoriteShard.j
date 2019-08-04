//! runtextmacro BaseStruct("MeteoriteShard", "METEORITE_SHARD")
    static constant real LIFE_INCREMENT = 100.
    static constant real MANA_INCREMENT = 30.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.MaxLife.Bonus.Subtract(thistype.LIFE_INCREMENT)
        call whichUnit.MaxMana.Bonus.Subtract(thistype.MANA_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.MaxLife.Bonus.Add(thistype.LIFE_INCREMENT)
        call whichUnit.MaxMana.Bonus.Add(thistype.MANA_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct