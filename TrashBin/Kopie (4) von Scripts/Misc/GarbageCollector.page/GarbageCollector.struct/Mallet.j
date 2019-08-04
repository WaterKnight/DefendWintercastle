//! runtextmacro BaseStruct("Mallet", "MALLET")
    static constant real DAMAGE_INCREMENT = 12.
    static constant real STRENGTH_INCREMENT = 4.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Strength.Bonus.Subtract(thistype.STRENGTH_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Strength.Bonus.Add(thistype.STRENGTH_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct