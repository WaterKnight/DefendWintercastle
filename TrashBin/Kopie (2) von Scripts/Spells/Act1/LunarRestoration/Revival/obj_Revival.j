static real array LIFE_FACTOR
static real array MANA_FACTOR
static real array DURATION
static integer array FIELD
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_Revival takes nothing returns nothing
    set thistype.LIFE_FACTOR[1] = 0.3
    set thistype.MANA_FACTOR[1] = 0.3
    set thistype.DURATION[1] = 4.5
    set thistype.FIELD[1] = 1
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
endmethod