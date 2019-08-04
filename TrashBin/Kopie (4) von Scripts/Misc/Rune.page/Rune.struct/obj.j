//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Rune.page\Rune.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IRun')
    call thistype.THIS_ITEM.Classes.Add(ItemClass.POWER_UP)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Rune.page\Rune.struct\obj_thisItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Rune.page\Rune.struct\obj_this.j
static real HEAL_LIFE_RELATIVE_AMOUNT = 0.15
static integer AREA_RANGE = 200
static integer SPAWN_AMOUNT_FOR_RUNE = 12
static integer DURATION = 20
static string AREA_EFFECT_PATH = "Abilities\\Spells\\Other\\Andt\\Andt.mdl"
static real HEAL_MANA_RELATIVE_AMOUNT = 0.15
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Rune.page\\Rune.struct\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Rune.page\Rune.struct\obj_this.j


private static method onInit takes nothing returns nothing
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod