static integer array DAMAGE_PER_BUFF
static real array KNOCK_BACK_DURATION
static integer array PICK_OFFSET
static integer array FIELD
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_Arrival takes nothing returns nothing
    set thistype.DAMAGE_PER_BUFF[1] = 20
    set thistype.KNOCK_BACK_DURATION[1] = 0.5
    set thistype.PICK_OFFSET[1] = -125
    set thistype.FIELD[1] = 1
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.DAMAGE_PER_BUFF[2] = 30
    set thistype.KNOCK_BACK_DURATION[2] = 0.5
    set thistype.PICK_OFFSET[2] = -125
    set thistype.FIELD[2] = 2
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.DAMAGE_PER_BUFF[3] = 40
    set thistype.KNOCK_BACK_DURATION[3] = 0.5
    set thistype.PICK_OFFSET[3] = -125
    set thistype.FIELD[3] = 3
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
endmethod