static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\this.wc3obj")
    set thistype.DAMAGE[1] = 10
    set thistype.DAMAGE[2] = 20
    set thistype.DAMAGE[3] = 30
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\this.wc3obj")
    call t.Destroy()
endmethod