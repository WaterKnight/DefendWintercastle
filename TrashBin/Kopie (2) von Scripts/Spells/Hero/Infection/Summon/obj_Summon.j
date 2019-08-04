static integer array SUMMON_DURATION
static integer array MAX_SUMMONS_AMOUNT
static string array SUMMON_UNIT_TYPE
static integer array FIELD
    
static method Init_obj_Summon takes nothing returns nothing
    set thistype.SUMMON_DURATION[1] = 23
    set thistype.MAX_SUMMONS_AMOUNT[1] = 4
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.DESCENDANT
    set thistype.FIELD[1] = 1
    set thistype.SUMMON_DURATION[2] = 23
    set thistype.MAX_SUMMONS_AMOUNT[2] = 4
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.DESCENDANT2
    set thistype.FIELD[2] = 2
    set thistype.SUMMON_DURATION[3] = 23
    set thistype.MAX_SUMMONS_AMOUNT[3] = 4
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.DESCENDANT3
    set thistype.FIELD[3] = 3
    set thistype.SUMMON_DURATION[4] = 23
    set thistype.MAX_SUMMONS_AMOUNT[4] = 4
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.DESCENDANT4
    set thistype.FIELD[4] = 4
    set thistype.SUMMON_DURATION[5] = 23
    set thistype.MAX_SUMMONS_AMOUNT[5] = 4
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.DESCENDANT5
    set thistype.FIELD[5] = 5
endmethod