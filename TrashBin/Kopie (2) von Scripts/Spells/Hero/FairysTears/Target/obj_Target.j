static integer array COLD_DURATION
static integer array MIN_DAMAGE_INTERVAL
static integer array FIELD
static real array DAMAGE_DELAY
static integer array DAMAGE
static integer array DAMAGE_SPELL_POWER_MOD_FACTOR
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.COLD_DURATION[1] = 1
    set thistype.MIN_DAMAGE_INTERVAL[1] = 2
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE_DELAY[1] = 0.9
    set thistype.DAMAGE[1] = 15
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[1] = 1
    set thistype.COLD_DURATION[2] = 2
    set thistype.MIN_DAMAGE_INTERVAL[2] = 2
    set thistype.FIELD[2] = 2
    set thistype.DAMAGE_DELAY[2] = 0.9
    set thistype.DAMAGE[2] = 25
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[2] = 1
    set thistype.COLD_DURATION[3] = 3
    set thistype.MIN_DAMAGE_INTERVAL[3] = 2
    set thistype.FIELD[3] = 3
    set thistype.DAMAGE_DELAY[3] = 0.9
    set thistype.DAMAGE[3] = 35
    set thistype.DAMAGE_SPELL_POWER_MOD_FACTOR[3] = 1
endmethod