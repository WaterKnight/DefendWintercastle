static integer array OFFSET
static integer array AREA_RANGE
static integer array SPEED
static integer array FIELD
static integer array DAMAGE
static integer array MAX_LENGTH
    
static method Init_obj_Wave takes nothing returns nothing
    set thistype.OFFSET[1] = 125
    set thistype.AREA_RANGE[1] = 125
    set thistype.SPEED[1] = 650
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE[1] = 40
    set thistype.MAX_LENGTH[1] = 600
endmethod