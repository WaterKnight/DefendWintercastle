static real array INTERVAL
static integer array DURATION
static integer array DAMAGE_PER_SECOND
static integer array FIELD
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.INTERVAL[1] = 0.35
    set thistype.DURATION[1] = 15
    set thistype.DAMAGE_PER_SECOND[1] = 30
    set thistype.FIELD[1] = 1
endmethod