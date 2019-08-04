static integer array FIELD
static integer array WAVES_AMOUNT
static integer array AREA_RANGE
static integer array DAMAGE
    
static method Init_obj_SetMines takes nothing returns nothing
    set thistype.FIELD[1] = 1
    set thistype.WAVES_AMOUNT[1] = 3
    set thistype.AREA_RANGE[1] = 200
    set thistype.DAMAGE[1] = 30
    set thistype.FIELD[2] = 2
    set thistype.WAVES_AMOUNT[2] = 3
    set thistype.AREA_RANGE[2] = 220
    set thistype.DAMAGE[2] = 45
    set thistype.FIELD[3] = 3
    set thistype.WAVES_AMOUNT[3] = 3
    set thistype.AREA_RANGE[3] = 240
    set thistype.DAMAGE[3] = 60
    set thistype.FIELD[4] = 4
    set thistype.WAVES_AMOUNT[4] = 3
    set thistype.AREA_RANGE[4] = 260
    set thistype.DAMAGE[4] = 80
    set thistype.FIELD[5] = 5
    set thistype.WAVES_AMOUNT[5] = 3
    set thistype.AREA_RANGE[5] = 280
    set thistype.DAMAGE[5] = 105
endmethod