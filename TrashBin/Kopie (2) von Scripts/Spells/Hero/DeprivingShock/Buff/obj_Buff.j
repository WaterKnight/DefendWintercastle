static integer array DURATION
static integer array EVASION_INCREMENT
static integer array FIELD
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.DURATION[1] = 8
    set thistype.EVASION_INCREMENT[1] = 35
    set thistype.FIELD[1] = 1
    set thistype.DURATION[2] = 8
    set thistype.EVASION_INCREMENT[2] = 60
    set thistype.FIELD[2] = 2
    set thistype.DURATION[3] = 8
    set thistype.EVASION_INCREMENT[3] = 85
    set thistype.FIELD[3] = 3
    set thistype.DURATION[4] = 8
    set thistype.EVASION_INCREMENT[4] = 110
    set thistype.FIELD[4] = 4
    set thistype.DURATION[5] = 8
    set thistype.EVASION_INCREMENT[5] = 135
    set thistype.FIELD[5] = 5
endmethod