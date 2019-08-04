static integer array PACKETS
static integer INCREASING_ITEMS_MAX = 7
static integer DECREASING_ITEMS_MAX = 7
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\this.wc3obj")
    set thistype.PACKETS[0] = 1
    set thistype.PACKETS[1] = 2
    set thistype.PACKETS[2] = 4
    set thistype.PACKETS[3] = 8
    set thistype.PACKETS[4] = 16
    set thistype.PACKETS[5] = 32
    set thistype.PACKETS[6] = 64
    set thistype.PACKETS[7] = 128
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\this.wc3obj")
    call t.Destroy()
endmethod