static integer array SPEED_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\this.wc3obj")
    set thistype.SPEED_INCREMENT[1] = -90
    set thistype.SPEED_INCREMENT[2] = -90
    set thistype.SPEED_INCREMENT[3] = -90
    set thistype.SPEED_INCREMENT[4] = -90
    set thistype.SPEED_INCREMENT[5] = -90
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 11
    set thistype.DURATION[4] = 14
    set thistype.DURATION[5] = 17
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FrozenStar.page\\FrozenStar.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod