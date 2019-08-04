static integer array DURATION
static integer array EVASION_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\this.wc3obj")
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 8
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 8
    set thistype.EVASION_INCREMENT[1] = 35
    set thistype.EVASION_INCREMENT[2] = 60
    set thistype.EVASION_INCREMENT[3] = 85
    set thistype.EVASION_INCREMENT[4] = 110
    set thistype.EVASION_INCREMENT[5] = 135
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod