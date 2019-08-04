static integer array MISS_INCREMENT
static real array ARMOR_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\this.wc3obj")
    set thistype.MISS_INCREMENT[1] = 30
    set thistype.MISS_INCREMENT[2] = 60
    set thistype.MISS_INCREMENT[3] = 90
    set thistype.MISS_INCREMENT[4] = 120
    set thistype.MISS_INCREMENT[5] = 150
    set thistype.ARMOR_INCREMENT[1] = -0.25
    set thistype.ARMOR_INCREMENT[2] = -0.25
    set thistype.ARMOR_INCREMENT[3] = -0.25
    set thistype.ARMOR_INCREMENT[4] = -0.25
    set thistype.ARMOR_INCREMENT[5] = -0.25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod