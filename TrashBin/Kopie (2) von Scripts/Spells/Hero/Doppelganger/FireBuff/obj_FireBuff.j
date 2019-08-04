static integer array FIRE_BUFF_DURATION
static real array FIRE_BUFF_DAMAGE_FACTOR
static integer array FIRE_BUFF_AREA_RANGE
static integer array FIELD
    
static method Init_obj_FireBuff takes nothing returns nothing
    set thistype.FIRE_BUFF_DURATION[1] = 30
    set thistype.FIRE_BUFF_DAMAGE_FACTOR[1] = 0.3
    set thistype.FIRE_BUFF_AREA_RANGE[1] = 125
    set thistype.FIELD[1] = 1
    set thistype.FIRE_BUFF_DURATION[2] = 30
    set thistype.FIRE_BUFF_DAMAGE_FACTOR[2] = 0.5
    set thistype.FIRE_BUFF_AREA_RANGE[2] = 140
    set thistype.FIELD[2] = 2
    set thistype.FIRE_BUFF_DURATION[3] = 30
    set thistype.FIRE_BUFF_DAMAGE_FACTOR[3] = 0.7
    set thistype.FIRE_BUFF_AREA_RANGE[3] = 160
    set thistype.FIELD[3] = 3
endmethod