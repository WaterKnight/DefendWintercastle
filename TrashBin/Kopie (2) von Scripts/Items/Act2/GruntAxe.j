//! runtextmacro BaseStruct("GruntAxe", "GRUNT_AXE")
    static constant real CRITICAL_CHANCE_INCREMENT = 50.
    static constant real DAMAGE_INCREMENT = 8.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Subtract(thistype.CRITICAL_CHANCE_INCREMENT)
        call whichUnit.Damage.Bonus.Subtract(thistype.DAMAGE_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.CriticalChance.Bonus.Add(thistype.CRITICAL_CHANCE_INCREMENT)
        call whichUnit.Damage.Bonus.Add(thistype.DAMAGE_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call ItemType.GRUNT_AXE.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call ItemType.GRUNT_AXE.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct