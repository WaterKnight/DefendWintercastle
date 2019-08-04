static real array DAMAGE_RELATIVE_INCREMENT
static integer array DURATION
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.DAMAGE_RELATIVE_INCREMENT[1] = 0.25
    set thistype.DURATION[1] = 20
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE_RELATIVE_INCREMENT[2] = 0.3
    set thistype.DURATION[2] = 20
    set thistype.FIELD[2] = 2
    set thistype.DAMAGE_RELATIVE_INCREMENT[3] = 0.375
    set thistype.DURATION[3] = 20
    set thistype.FIELD[3] = 3
    set thistype.DAMAGE_RELATIVE_INCREMENT[4] = 0.475
    set thistype.DURATION[4] = 20
    set thistype.FIELD[4] = 4
    set thistype.DAMAGE_RELATIVE_INCREMENT[5] = 0.6
    set thistype.DURATION[5] = 20
    set thistype.FIELD[5] = 5
endmethod