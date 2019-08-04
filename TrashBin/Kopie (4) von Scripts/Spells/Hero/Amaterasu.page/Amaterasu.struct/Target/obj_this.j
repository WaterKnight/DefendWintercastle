static integer DURATION = 1
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod