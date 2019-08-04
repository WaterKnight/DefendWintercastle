static integer DURATION = 5
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod