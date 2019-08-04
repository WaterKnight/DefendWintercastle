static integer STUN_DURATION = 2
static integer BUFF_DURATION = 5
static integer DAMAGE = 30
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Knockout.page\\Knockout.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Knockout.page\\Knockout.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod