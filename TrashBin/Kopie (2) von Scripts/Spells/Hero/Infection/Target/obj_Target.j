static integer array ARMOR_INCREMENT
static integer array TARGET_DURATION
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.ARMOR_INCREMENT[1] = -3
    set thistype.TARGET_DURATION[1] = 5
    set thistype.FIELD[1] = 1
    set thistype.ARMOR_INCREMENT[2] = -5
    set thistype.TARGET_DURATION[2] = 5
    set thistype.FIELD[2] = 2
    set thistype.ARMOR_INCREMENT[3] = -7
    set thistype.TARGET_DURATION[3] = 5
    set thistype.FIELD[3] = 3
    set thistype.ARMOR_INCREMENT[4] = -9
    set thistype.TARGET_DURATION[4] = 5
    set thistype.FIELD[4] = 4
    set thistype.ARMOR_INCREMENT[5] = -11
    set thistype.TARGET_DURATION[5] = 5
    set thistype.FIELD[5] = 5
endmethod