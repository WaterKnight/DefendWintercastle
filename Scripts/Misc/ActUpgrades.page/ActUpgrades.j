//! runtextmacro BaseStruct("ActUpgrades", "ACT_UPGRADES")
    static constant integer RESERVOIR_MANA_INCREMENT = 100

    enumMethod Reservoir
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(thistype.RESERVOIR_MANA_INCREMENT), "ff0000ff"), 0.032, 60., 1., 2.5, TextTag.GetFreeId())
        call target.MaxMana.Base.Add(thistype.RESERVOIR_MANA_INCREMENT)
    endmethod

    enumMethod Tower
        local Unit target = UNIT.Event.Native.GetEnum()

        call target.Damage.Base.Add(15)
    endmethod

    eventMethod Event_ActEnding
        local Act whichAct = params.Act.GetTrigger()

        if whichAct.IsBonus() then
            return
        endif

        call Unit.EnumOfType(UnitType.RESERVOIR, function thistype.Reservoir)
        call Unit.EnumOfType(UnitType.TOWER, function thistype.Tower)
    endmethod

    initMethod Init of Misc_4
        call Event.Create(Act.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActEnding).AddToStatics()
    endmethod
endstruct