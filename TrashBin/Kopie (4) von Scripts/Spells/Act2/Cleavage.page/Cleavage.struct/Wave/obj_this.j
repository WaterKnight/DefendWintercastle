static integer OFFSET = 125
static integer AREA_RANGE = 125
static integer SPEED = 650
static integer DAMAGE = 40
static integer MAX_LENGTH = 600
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\this.wc3obj")
    call t.Destroy()
endmethod