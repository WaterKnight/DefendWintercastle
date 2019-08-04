static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\this.wc3obj")
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 4
    set thistype.DURATION[3] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\this.wc3obj")
    call t.Destroy()
endmethod