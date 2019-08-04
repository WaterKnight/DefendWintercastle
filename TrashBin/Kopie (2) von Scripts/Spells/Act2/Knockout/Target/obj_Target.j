static integer array BUFF_DURATION
static integer array FIELD
static integer array STUN_DURATION
static integer array DAMAGE
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.BUFF_DURATION[1] = 5
    set thistype.FIELD[1] = 1
    set thistype.STUN_DURATION[1] = 2
    set thistype.DAMAGE[1] = 30
endmethod