static integer array SPEED_INCREMENT
static integer array BUFF_DURATION
static integer array FIELD
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.SPEED_INCREMENT[1] = -100
    set thistype.BUFF_DURATION[1] = 8
    set thistype.FIELD[1] = 1
    set thistype.SPEED_INCREMENT[2] = -125
    set thistype.BUFF_DURATION[2] = 9
    set thistype.FIELD[2] = 2
    set thistype.SPEED_INCREMENT[3] = -150
    set thistype.BUFF_DURATION[3] = 10
    set thistype.FIELD[3] = 3
    set thistype.SPEED_INCREMENT[4] = -175
    set thistype.BUFF_DURATION[4] = 11
    set thistype.FIELD[4] = 4
    set thistype.SPEED_INCREMENT[5] = -200
    set thistype.BUFF_DURATION[5] = 12
    set thistype.FIELD[5] = 5
endmethod