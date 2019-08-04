static integer array SPEED_INCREMENT
static integer array BUFF_DURATION
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.SPEED_INCREMENT[1] = -90
    set thistype.BUFF_DURATION[1] = 5
    set thistype.FIELD[1] = 1
    set thistype.SPEED_INCREMENT[2] = -90
    set thistype.BUFF_DURATION[2] = 8
    set thistype.FIELD[2] = 2
    set thistype.SPEED_INCREMENT[3] = -90
    set thistype.BUFF_DURATION[3] = 11
    set thistype.FIELD[3] = 3
    set thistype.SPEED_INCREMENT[4] = -90
    set thistype.BUFF_DURATION[4] = 14
    set thistype.FIELD[4] = 4
    set thistype.SPEED_INCREMENT[5] = -90
    set thistype.BUFF_DURATION[5] = 17
    set thistype.FIELD[5] = 5
endmethod