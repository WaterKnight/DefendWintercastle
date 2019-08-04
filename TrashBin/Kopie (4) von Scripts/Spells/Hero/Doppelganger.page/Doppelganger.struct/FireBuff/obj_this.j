static integer array DURATION
static integer array AREA_RANGE
static real array DAMAGE_FACTOR
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\this.wc3obj")
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 30
    set thistype.DURATION[3] = 30
    set thistype.AREA_RANGE[1] = 125
    set thistype.AREA_RANGE[2] = 140
    set thistype.AREA_RANGE[3] = 160
    set thistype.DAMAGE_FACTOR[1] = 0.3
    set thistype.DAMAGE_FACTOR[2] = 0.5
    set thistype.DAMAGE_FACTOR[3] = 0.7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\this.wc3obj")
    call t.Destroy()
endmethod