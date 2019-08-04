//! runtextmacro BaseStruct("ActUpgrades", "ACT_UPGRADES")
    static constant integer RESERVOIR_MANA_INCREMENT = 100

    static method Reservoir takes nothing returns nothing
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(thistype.RESERVOIR_MANA_INCREMENT), "ff0000ff"), 0.032, 60., 1., 2.5, TextTag.GetFreeId())
        call target.MaxMana.Add(thistype.RESERVOIR_MANA_INCREMENT)
    endmethod

    static method Tower takes nothing returns nothing
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.Damage.Add(15)
    endmethod

    static method Event_ActEnding takes nothing returns nothing
        local Act whichAct = ACT.Event.GetTrigger()

        if (whichAct.IsBonus()) then
            return
        endif

        call Unit.EnumOfType(UnitType.RESERVOIR, function thistype.Reservoir)
        call Unit.EnumOfType(UnitType.TOWER, function thistype.Tower)
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(Act.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActEnding).AddToStatics()
    endmethod
endstruct