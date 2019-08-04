//! runtextmacro BaseStruct("RamblersStick", "RAMBLERS_STICK")
    static constant real ARMOR_INCREMENT = 1.
    static constant real DAMAGE_INCREMENT = 5.
    static constant real INTELLIGENCE_INCREMENT = 4.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Armor.Bonus.Subtract(thistype.ARMOR_INCREMENT)
        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Armor.Bonus.Add(thistype.ARMOR_INCREMENT)
        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call ItemType.RAMBLERS_STICK.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call ItemType.RAMBLERS_STICK.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct