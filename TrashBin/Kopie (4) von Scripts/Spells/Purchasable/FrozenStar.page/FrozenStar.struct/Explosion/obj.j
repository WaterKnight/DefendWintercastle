//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Explosion\obj_this.j
static integer array DAMAGE
static string SPECIAL_EFFECT_PATH = "Units\\NightElf\\Wisp\\WispExplode.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Explosion\\this.wc3obj")
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 60
    set thistype.DAMAGE[4] = 70
    set thistype.DAMAGE[5] = 80
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Explosion\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.struct\Explosion\obj_this.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod