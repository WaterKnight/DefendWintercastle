static integer array DRAW_BACK_DAMAGE
static integer array FIELD
static string array TARGET_EFFECT_PATH
static string array DRAW_BACK_WINDOW
static integer array DRAW_BACK_MISSILES_AMOUNT
static integer array DRAW_BACK_AREA_RANGE
static integer array DRAW_BACK_MAX_LENGTH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_Drawback takes nothing returns nothing
    set thistype.DRAW_BACK_DAMAGE[1] = 20
    set thistype.FIELD[1] = 1
    set thistype.TARGET_EFFECT_PATH[1] = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    set thistype.DRAW_BACK_WINDOW[1] = "2./3 * Math.QUARTER_ANGLE"
    set thistype.DRAW_BACK_MISSILES_AMOUNT[1] = 3
    set thistype.DRAW_BACK_AREA_RANGE[1] = 60
    set thistype.DRAW_BACK_MAX_LENGTH[1] = 550
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.DRAW_BACK_DAMAGE[2] = 30
    set thistype.FIELD[2] = 2
    set thistype.TARGET_EFFECT_PATH[2] = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    set thistype.DRAW_BACK_WINDOW[2] = "2./3 * Math.QUARTER_ANGLE"
    set thistype.DRAW_BACK_MISSILES_AMOUNT[2] = 3
    set thistype.DRAW_BACK_AREA_RANGE[2] = 60
    set thistype.DRAW_BACK_MAX_LENGTH[2] = 550
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.DRAW_BACK_DAMAGE[3] = 40
    set thistype.FIELD[3] = 3
    set thistype.TARGET_EFFECT_PATH[3] = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    set thistype.DRAW_BACK_WINDOW[3] = "2./3 * Math.QUARTER_ANGLE"
    set thistype.DRAW_BACK_MISSILES_AMOUNT[3] = 4
    set thistype.DRAW_BACK_AREA_RANGE[3] = 60
    set thistype.DRAW_BACK_MAX_LENGTH[3] = 550
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.DRAW_BACK_DAMAGE[4] = 50
    set thistype.FIELD[4] = 3
    set thistype.TARGET_EFFECT_PATH[4] = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    set thistype.DRAW_BACK_WINDOW[4] = "2./3 * Math.QUARTER_ANGLE"
    set thistype.DRAW_BACK_MISSILES_AMOUNT[4] = 4
    set thistype.DRAW_BACK_AREA_RANGE[4] = 60
    set thistype.DRAW_BACK_MAX_LENGTH[4] = 550
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.CHEST
    set thistype.DRAW_BACK_DAMAGE[5] = 60
    set thistype.FIELD[5] = 3
    set thistype.TARGET_EFFECT_PATH[5] = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    set thistype.DRAW_BACK_WINDOW[5] = "2./3 * Math.QUARTER_ANGLE"
    set thistype.DRAW_BACK_MISSILES_AMOUNT[5] = 5
    set thistype.DRAW_BACK_AREA_RANGE[5] = 60
    set thistype.DRAW_BACK_MAX_LENGTH[5] = 550
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.CHEST
endmethod