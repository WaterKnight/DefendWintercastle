static integer array DAMAGE_INCREMENT
static integer array HEAL
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.DAMAGE_INCREMENT[1] = 25
    set thistype.HEAL[1] = 30
    set thistype.FIELD[1] = 1
endmethod