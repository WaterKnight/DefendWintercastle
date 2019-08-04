static integer array DAMAGE_INCREMENT
static integer array DURATION
static integer array FIELD
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.DAMAGE_INCREMENT[1] = 15
    set thistype.DURATION[1] = 8
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE_INCREMENT[2] = 25
    set thistype.DURATION[2] = 8
    set thistype.FIELD[2] = 2
    set thistype.DAMAGE_INCREMENT[3] = 35
    set thistype.DURATION[3] = 8
    set thistype.FIELD[3] = 3
    set thistype.DAMAGE_INCREMENT[4] = 45
    set thistype.DURATION[4] = 8
    set thistype.FIELD[4] = 4
    set thistype.DAMAGE_INCREMENT[5] = 55
    set thistype.DURATION[5] = 8
    set thistype.FIELD[5] = 5
endmethod