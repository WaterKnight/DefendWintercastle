static integer array SPEED
static integer array FIELD
static integer array DAMAGE_PER_SHARD
static integer array MAX_LENGTH
    
static method Init_obj_Particle takes nothing returns nothing
    set thistype.SPEED[1] = 700
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE_PER_SHARD[1] = 7
    set thistype.MAX_LENGTH[1] = 400
    set thistype.SPEED[2] = 700
    set thistype.FIELD[2] = 2
    set thistype.DAMAGE_PER_SHARD[2] = 13
    set thistype.MAX_LENGTH[2] = 500
    set thistype.SPEED[3] = 700
    set thistype.FIELD[3] = 3
    set thistype.DAMAGE_PER_SHARD[3] = 21
    set thistype.MAX_LENGTH[3] = 600
    set thistype.SPEED[4] = 700
    set thistype.FIELD[4] = 4
    set thistype.DAMAGE_PER_SHARD[4] = 31
    set thistype.MAX_LENGTH[4] = 700
    set thistype.SPEED[5] = 700
    set thistype.FIELD[5] = 5
    set thistype.DAMAGE_PER_SHARD[5] = 43
    set thistype.MAX_LENGTH[5] = 800
endmethod