static integer array MISS_INCREMENT
static real array ARMOR_INCREMENT
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.MISS_INCREMENT[1] = 30
    set thistype.ARMOR_INCREMENT[1] = -0.25
    set thistype.FIELD[1] = 1
    set thistype.MISS_INCREMENT[2] = 60
    set thistype.ARMOR_INCREMENT[2] = -0.25
    set thistype.FIELD[2] = 2
    set thistype.MISS_INCREMENT[3] = 90
    set thistype.ARMOR_INCREMENT[3] = -0.25
    set thistype.FIELD[3] = 3
    set thistype.MISS_INCREMENT[4] = 120
    set thistype.ARMOR_INCREMENT[4] = -0.25
    set thistype.FIELD[4] = 4
    set thistype.MISS_INCREMENT[5] = 150
    set thistype.ARMOR_INCREMENT[5] = -0.25
    set thistype.FIELD[5] = 5
endmethod