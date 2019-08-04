//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard.page\Blizzard.struct\Wave\obj_this.j
static integer array DAMAGE
static real DAMAGE_DELAY = 0.8
static integer array DEBRIS_AMOUNT
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Blizzard\\BlizzardTarget.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Blizzard.page\\Blizzard.struct\\Wave\\this.wc3obj")
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 40
    set thistype.DAMAGE[4] = 50
    set thistype.DAMAGE[5] = 60
    set thistype.DEBRIS_AMOUNT[1] = 5
    set thistype.DEBRIS_AMOUNT[2] = 6
    set thistype.DEBRIS_AMOUNT[3] = 7
    set thistype.DEBRIS_AMOUNT[4] = 8
    set thistype.DEBRIS_AMOUNT[5] = 9
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Blizzard.page\\Blizzard.struct\\Wave\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard.page\Blizzard.struct\Wave\obj_this.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod