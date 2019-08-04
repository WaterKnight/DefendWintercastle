//! runtextmacro BaseStruct("ElfinDagger", "ELFIN_DAGGER")
    static constant real DAMAGE_INCREMENT = 0.25
    static constant real INTELLIGENCE_INCREMENT = 10.

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Damage.SpellRelative.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.Damage.SpellRelative.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct