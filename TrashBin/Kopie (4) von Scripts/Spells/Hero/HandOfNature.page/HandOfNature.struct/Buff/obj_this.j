static integer array DAMAGE
static real INTERVAL = 0.5
static integer array EVASION_INCREMENT
static real array DURATION
static integer array HERO_DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\this.wc3obj")
    set thistype.DAMAGE[1] = 40
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 40
    set thistype.DAMAGE[4] = 40
    set thistype.DAMAGE[5] = 40
    set thistype.EVASION_INCREMENT[1] = -40
    set thistype.EVASION_INCREMENT[2] = -50
    set thistype.EVASION_INCREMENT[3] = -60
    set thistype.EVASION_INCREMENT[4] = -70
    set thistype.EVASION_INCREMENT[5] = -80
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 3.5
    set thistype.DURATION[3] = 4
    set thistype.DURATION[4] = 4.5
    set thistype.DURATION[5] = 5
    set thistype.HERO_DURATION[1] = 1
    set thistype.HERO_DURATION[2] = 1
    set thistype.HERO_DURATION[3] = 1
    set thistype.HERO_DURATION[4] = 1
    set thistype.HERO_DURATION[5] = 1
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod