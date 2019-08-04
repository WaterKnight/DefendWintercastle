static integer array ARMOR_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\this.wc3obj")
    set thistype.ARMOR_INCREMENT[1] = -3
    set thistype.ARMOR_INCREMENT[2] = -5
    set thistype.ARMOR_INCREMENT[3] = -7
    set thistype.ARMOR_INCREMENT[4] = -9
    set thistype.ARMOR_INCREMENT[5] = -11
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 5
    set thistype.DURATION[3] = 5
    set thistype.DURATION[4] = 5
    set thistype.DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod