//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\PandaPaw.struct\Arrival\obj_this.j
static real array DURATION
static integer PICK_OFFSET = -125
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\Arrival\\this.wc3obj")
    set thistype.DURATION[1] = 0.5
    set thistype.DURATION[2] = 0.5
    set thistype.DURATION[3] = 0.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\Arrival\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\PandaPaw.struct\Arrival\obj_this.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod