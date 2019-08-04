//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Target\obj_this.j
static integer DURATION = 5
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod