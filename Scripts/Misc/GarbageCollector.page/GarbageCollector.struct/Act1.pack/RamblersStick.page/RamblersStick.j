//! runtextmacro BaseStruct("RamblersStick", "RAMBLERS_STICK")
    static constant real ARMOR_INCREMENT = 1.
    static constant real DAMAGE_INCREMENT = 5.
    static constant real INTELLIGENCE_INCREMENT = 4.

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Armor.Bonus.Subtract(thistype.ARMOR_INCREMENT)
        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Armor.Bonus.Add(thistype.ARMOR_INCREMENT)
        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct