static integer array DEBRIS_AMOUNT
static integer array FIELD
static real array DAMAGE_DELAY
static integer array DAMAGE
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_Wave takes nothing returns nothing
    set thistype.DEBRIS_AMOUNT[1] = 5
    set thistype.FIELD[1] = 1
    set thistype.DAMAGE_DELAY[1] = 0.8
    set thistype.DAMAGE[1] = 20
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
    set thistype.DEBRIS_AMOUNT[2] = 6
    set thistype.FIELD[2] = 2
    set thistype.DAMAGE_DELAY[2] = 0.8
    set thistype.DAMAGE[2] = 30
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
    set thistype.DEBRIS_AMOUNT[3] = 7
    set thistype.FIELD[3] = 3
    set thistype.DAMAGE_DELAY[3] = 0.8
    set thistype.DAMAGE[3] = 40
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
    set thistype.DEBRIS_AMOUNT[4] = 8
    set thistype.FIELD[4] = 4
    set thistype.DAMAGE_DELAY[4] = 0.8
    set thistype.DAMAGE[4] = 50
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
    set thistype.DEBRIS_AMOUNT[5] = 9
    set thistype.FIELD[5] = 5
    set thistype.DAMAGE_DELAY[5] = 0.8
    set thistype.DAMAGE[5] = 60
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
endmethod