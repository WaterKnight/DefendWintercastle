static integer array DAMAGE
static integer array AREA_RANGE
static real array WINDOW
static string TARGET_EFFECT_PATH = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
static integer array MISSILES_AMOUNT
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static integer array MAX_LENGTH
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\RazorBlade.struct\\Drawback\\this.wc3obj")
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 40
    set thistype.AREA_RANGE[1] = 60
    set thistype.AREA_RANGE[2] = 60
    set thistype.AREA_RANGE[3] = 60
    set thistype.WINDOW[1] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[2] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[3] = 2./3 * Math.QUARTER_ANGLE
    set thistype.MISSILES_AMOUNT[1] = 3
    set thistype.MISSILES_AMOUNT[2] = 3
    set thistype.MISSILES_AMOUNT[3] = 4
    set thistype.MAX_LENGTH[1] = 550
    set thistype.MAX_LENGTH[2] = 550
    set thistype.MAX_LENGTH[3] = 550
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\RazorBlade.struct\\Drawback\\this.wc3obj")
    call t.Destroy()
endmethod