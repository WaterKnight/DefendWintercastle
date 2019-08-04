static real MOVE_DURATION = 0.5
static integer STUN_DURATION = 2
static real EXPLOSION_DELAY = 1.5
static integer MOVE_Z_SPEED_START = 40
static real FRIENDLY_FIRE_FACTOR = 0.25
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\this.wc3obj")
    call t.Destroy()
endmethod