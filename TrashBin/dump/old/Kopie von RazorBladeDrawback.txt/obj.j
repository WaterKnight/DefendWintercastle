//open obj D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\Kopie von RazorBladeDrawback.txt\obj_this.j
static string TARGET_EFFECT_ATTACH_POINT = AttachPoint.CHEST
static string TARGET_EFFECT_PATH = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
static integer array AREA_RANGE
static real array WINDOW
static integer array MISSILES_AMOUNT
static integer array MAX_LENGTH
static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\Kopie von RazorBladeDrawback.txt\\this.wc3obj")
    set thistype.AREA_RANGE[1] = 60
    set thistype.AREA_RANGE[2] = 60
    set thistype.AREA_RANGE[3] = 60
    set thistype.AREA_RANGE[4] = 60
    set thistype.AREA_RANGE[5] = 60
    set thistype.WINDOW[1] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[2] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[3] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[4] = 2./3 * Math.QUARTER_ANGLE
    set thistype.WINDOW[5] = 2./3 * Math.QUARTER_ANGLE
    set thistype.MISSILES_AMOUNT[1] = 3
    set thistype.MISSILES_AMOUNT[2] = 3
    set thistype.MISSILES_AMOUNT[3] = 4
    set thistype.MISSILES_AMOUNT[4] = 4
    set thistype.MISSILES_AMOUNT[5] = 5
    set thistype.MAX_LENGTH[1] = 550
    set thistype.MAX_LENGTH[2] = 550
    set thistype.MAX_LENGTH[3] = 550
    set thistype.MAX_LENGTH[4] = 550
    set thistype.MAX_LENGTH[5] = 550
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 40
    set thistype.DAMAGE[4] = 50
    set thistype.DAMAGE[5] = 60
    call t.Destroy()
endmethod
//close obj D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\Kopie von RazorBladeDrawback.txt\obj_this.j

//open obj D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\Kopie von RazorBladeDrawback.txt\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qRBD'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\Kopie von RazorBladeDrawback.txt\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close obj D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\Kopie von RazorBladeDrawback.txt\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod