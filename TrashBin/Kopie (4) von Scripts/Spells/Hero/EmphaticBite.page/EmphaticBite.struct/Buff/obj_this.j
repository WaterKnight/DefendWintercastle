static integer array DAMAGE_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\this.wc3obj")
    set thistype.DAMAGE_INCREMENT[1] = 15
    set thistype.DAMAGE_INCREMENT[2] = 25
    set thistype.DAMAGE_INCREMENT[3] = 35
    set thistype.DAMAGE_INCREMENT[4] = 45
    set thistype.DAMAGE_INCREMENT[5] = 55
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 8
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 8
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod