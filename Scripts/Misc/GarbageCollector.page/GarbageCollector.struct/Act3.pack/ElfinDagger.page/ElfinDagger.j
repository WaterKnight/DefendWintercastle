//! runtextmacro BaseStruct("ElfinDagger", "ELFIN_DAGGER")
    static constant real DAMAGE_INCREMENT = 0.25
    static constant real INTELLIGENCE_INCREMENT = 10.

    eventMethod Event_Drop
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Damage.SpellRelative.Subtract(thistype.DAMAGE_INCREMENT)
        call whichUnit.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    eventMethod Event_PickUp
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Damage.SpellRelative.Add(thistype.DAMAGE_INCREMENT)
        call whichUnit.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    initMethod Init of Items_Act3
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
    endmethod
endstruct