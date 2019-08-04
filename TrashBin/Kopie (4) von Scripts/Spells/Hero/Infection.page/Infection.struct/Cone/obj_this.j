static integer END_WIDTH = 300
static integer SPEED = 650
static integer START_WIDTH = 0
static integer array DAMAGE
static integer MAX_LENGTH = 500
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\this.wc3obj")
    set thistype.DAMAGE[1] = 10
    set thistype.DAMAGE[2] = 15
    set thistype.DAMAGE[3] = 25
    set thistype.DAMAGE[4] = 35
    set thistype.DAMAGE[5] = 45
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\this.wc3obj")
    call t.Destroy()
endmethod