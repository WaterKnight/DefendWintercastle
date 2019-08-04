static integer REMAINING_LIFE_MIN_FACTOR = 0
static integer array DURATION
static real array INVULNERABILITY_DURATION
static real HEAL_FACTOR = 0.5
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\this.wc3obj")
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 30
    set thistype.DURATION[3] = 30
    set thistype.DURATION[4] = 30
    set thistype.DURATION[5] = 30
    set thistype.INVULNERABILITY_DURATION[1] = 1.5
    set thistype.INVULNERABILITY_DURATION[2] = 1.5
    set thistype.INVULNERABILITY_DURATION[3] = 1.5
    set thistype.INVULNERABILITY_DURATION[4] = 1.5
    set thistype.INVULNERABILITY_DURATION[5] = 1.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\this.wc3obj")
    call t.Destroy()
endmethod