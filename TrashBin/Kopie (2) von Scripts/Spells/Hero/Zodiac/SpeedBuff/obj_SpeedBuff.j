static real array SPEED_RELATIVE_INCREMENT
static integer array FIELD
    
static method Init_obj_SpeedBuff takes nothing returns nothing
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.25
    set thistype.FIELD[1] = 1
    set thistype.SPEED_RELATIVE_INCREMENT[2] = 0.35
    set thistype.FIELD[2] = 1
    set thistype.SPEED_RELATIVE_INCREMENT[3] = 0.4
    set thistype.FIELD[3] = 1
    set thistype.SPEED_RELATIVE_INCREMENT[4] = 0.45
    set thistype.FIELD[4] = 1
    set thistype.SPEED_RELATIVE_INCREMENT[5] = 0.5
    set thistype.FIELD[5] = 1
endmethod