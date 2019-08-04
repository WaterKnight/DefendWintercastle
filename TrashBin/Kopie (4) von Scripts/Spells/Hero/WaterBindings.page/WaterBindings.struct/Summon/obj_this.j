static integer OFFSET = 75
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\this.wc3obj")
    set thistype.DURATION[1] = 25
    set thistype.DURATION[2] = 25
    set thistype.DURATION[3] = 25
    set thistype.DURATION[4] = 25
    set thistype.DURATION[5] = 25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WaterBindings.page\\WaterBindings.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod