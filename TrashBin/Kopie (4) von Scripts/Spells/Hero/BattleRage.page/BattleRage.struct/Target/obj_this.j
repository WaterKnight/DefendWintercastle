static real array DAMAGE_RELATIVE_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\Target\\this.wc3obj")
    set thistype.DAMAGE_RELATIVE_INCREMENT[1] = 0.25
    set thistype.DAMAGE_RELATIVE_INCREMENT[2] = 0.3
    set thistype.DAMAGE_RELATIVE_INCREMENT[3] = 0.375
    set thistype.DAMAGE_RELATIVE_INCREMENT[4] = 0.475
    set thistype.DAMAGE_RELATIVE_INCREMENT[5] = 0.6
    set thistype.DURATION[1] = 20
    set thistype.DURATION[2] = 20
    set thistype.DURATION[3] = 20
    set thistype.DURATION[4] = 20
    set thistype.DURATION[5] = 20
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod