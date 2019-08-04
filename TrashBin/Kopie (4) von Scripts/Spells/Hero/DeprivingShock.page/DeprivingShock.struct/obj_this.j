static real TRANSFERED_MANA_FACTOR = 0.5
static integer array STUN_DURATION
static string EFFECT_LIGHTNING_PATH = "MBUR"
static integer array BURNED_MANA
static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\this.wc3obj")
    set thistype.STUN_DURATION[1] = 1
    set thistype.STUN_DURATION[2] = 1
    set thistype.STUN_DURATION[3] = 1
    set thistype.STUN_DURATION[4] = 1
    set thistype.STUN_DURATION[5] = 1
    set thistype.BURNED_MANA[1] = 65
    set thistype.BURNED_MANA[2] = 100
    set thistype.BURNED_MANA[3] = 140
    set thistype.BURNED_MANA[4] = 185
    set thistype.BURNED_MANA[5] = 235
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 45
    set thistype.DAMAGE[4] = 60
    set thistype.DAMAGE[5] = 75
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\this.wc3obj")
    call t.Destroy()
endmethod