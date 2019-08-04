static real array BUFF_DURATION
static integer array FIELD
static real array ATTACK_SPEED_INCREMENT
static integer array CRITICAL_INCREMENT
    
static method Init_obj_CriticalAttacks takes nothing returns nothing
    set thistype.BUFF_DURATION[1] = 7.5
    set thistype.FIELD[1] = 1
    set thistype.ATTACK_SPEED_INCREMENT[1] = 0.25
    set thistype.CRITICAL_INCREMENT[1] = 40
    set thistype.BUFF_DURATION[2] = 7.5
    set thistype.FIELD[2] = 2
    set thistype.ATTACK_SPEED_INCREMENT[2] = 0.4
    set thistype.CRITICAL_INCREMENT[2] = 60
    set thistype.BUFF_DURATION[3] = 7.5
    set thistype.FIELD[3] = 3
    set thistype.ATTACK_SPEED_INCREMENT[3] = 0.65
    set thistype.CRITICAL_INCREMENT[3] = 80
    set thistype.BUFF_DURATION[4] = 7.5
    set thistype.FIELD[4] = 4
    set thistype.ATTACK_SPEED_INCREMENT[4] = 0.8
    set thistype.CRITICAL_INCREMENT[4] = 100
    set thistype.BUFF_DURATION[5] = 7.5
    set thistype.FIELD[5] = 5
    set thistype.ATTACK_SPEED_INCREMENT[5] = 0.95
    set thistype.CRITICAL_INCREMENT[5] = 120
endmethod