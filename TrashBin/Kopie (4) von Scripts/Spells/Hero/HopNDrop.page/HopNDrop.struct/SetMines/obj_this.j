static integer WAVES_AMOUNT = 3
static integer array AREA_RANGE
static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\this.wc3obj")
    set thistype.AREA_RANGE[1] = 200
    set thistype.AREA_RANGE[2] = 220
    set thistype.AREA_RANGE[3] = 240
    set thistype.AREA_RANGE[4] = 260
    set thistype.AREA_RANGE[5] = 280
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 45
    set thistype.DAMAGE[3] = 60
    set thistype.DAMAGE[4] = 80
    set thistype.DAMAGE[5] = 105
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\this.wc3obj")
    call t.Destroy()
endmethod