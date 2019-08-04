static integer array FIELD
static real array INTERVAL
static integer array DAMAGE_PER_SECOND
static integer array DURATION
static integer array HERO_DURATION
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.FIELD[1] = 1
    set thistype.INTERVAL[1] = 0.5
    set thistype.DAMAGE_PER_SECOND[1] = 5
    set thistype.DURATION[1] = 4
    set thistype.HERO_DURATION[1] = 2
endmethod