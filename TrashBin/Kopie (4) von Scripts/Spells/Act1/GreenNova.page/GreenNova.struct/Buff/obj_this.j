static integer DURATION = 6
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\GreenNova.page\\GreenNova.struct\\Buff\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\GreenNova.page\\GreenNova.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod