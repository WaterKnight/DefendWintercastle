static integer array ARMOR_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\Buff\\this.wc3obj")
    set thistype.ARMOR_INCREMENT[1] = -3
    set thistype.ARMOR_INCREMENT[2] = -6
    set thistype.ARMOR_INCREMENT[3] = -9
    set thistype.ARMOR_INCREMENT[4] = -12
    set thistype.ARMOR_INCREMENT[5] = -15
    set thistype.DURATION[1] = 10
    set thistype.DURATION[2] = 10
    set thistype.DURATION[3] = 10
    set thistype.DURATION[4] = 10
    set thistype.DURATION[5] = 10
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod