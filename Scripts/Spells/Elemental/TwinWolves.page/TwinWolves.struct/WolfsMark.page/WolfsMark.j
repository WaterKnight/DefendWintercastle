//! runtextmacro BaseStruct("WolfsMark", "WOLFS_MARK")
    static method AddToUnit takes Unit target, integer level returns nothing
        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
    endmethod
endstruct