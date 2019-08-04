//! runtextmacro BaseStruct("Mallet", "MALLET")
    static constant real DAMAGE_INCREMENT = 12.
    static constant real STRENGTH_INCREMENT = 4.

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Strength.Bonus.Subtract(thistype.STRENGTH_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Strength.Bonus.Add(thistype.STRENGTH_INCREMENT)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct