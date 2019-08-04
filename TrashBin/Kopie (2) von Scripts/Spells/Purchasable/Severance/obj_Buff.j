static integer array ARMOR_INCREMENT
static integer array DURATION
static integer array FIELD
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.ARMOR_INCREMENT[1] = -3
    set thistype.DURATION[1] = 10
    set thistype.FIELD[1] = 1
    set thistype.ARMOR_INCREMENT[2] = -6
    set thistype.DURATION[2] = 10
    set thistype.FIELD[2] = 2
    set thistype.ARMOR_INCREMENT[3] = -9
    set thistype.DURATION[3] = 10
    set thistype.FIELD[3] = 3
    set thistype.ARMOR_INCREMENT[4] = -12
    set thistype.DURATION[4] = 10
    set thistype.FIELD[4] = 4
    set thistype.ARMOR_INCREMENT[5] = -15
    set thistype.DURATION[5] = 10
    set thistype.FIELD[5] = 5
endmethod