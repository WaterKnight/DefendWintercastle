static integer array MAX_AMOUNT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\this.wc3obj")
    set thistype.MAX_AMOUNT[1] = 4
    set thistype.MAX_AMOUNT[2] = 4
    set thistype.MAX_AMOUNT[3] = 4
    set thistype.MAX_AMOUNT[4] = 4
    set thistype.MAX_AMOUNT[5] = 4
    set thistype.DURATION[1] = 23
    set thistype.DURATION[2] = 23
    set thistype.DURATION[3] = 23
    set thistype.DURATION[4] = 23
    set thistype.DURATION[5] = 23
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod