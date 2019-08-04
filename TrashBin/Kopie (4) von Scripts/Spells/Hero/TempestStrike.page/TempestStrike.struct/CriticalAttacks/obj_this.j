static real DURATION = 7.5
static integer array CRITICAL_INCREMENT
static real array ATTACK_SPEED_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\this.wc3obj")
    set thistype.CRITICAL_INCREMENT[1] = 40
    set thistype.CRITICAL_INCREMENT[2] = 60
    set thistype.CRITICAL_INCREMENT[3] = 80
    set thistype.CRITICAL_INCREMENT[4] = 100
    set thistype.CRITICAL_INCREMENT[5] = 120
    set thistype.ATTACK_SPEED_INCREMENT[1] = 0.25
    set thistype.ATTACK_SPEED_INCREMENT[2] = 0.4
    set thistype.ATTACK_SPEED_INCREMENT[3] = 0.65
    set thistype.ATTACK_SPEED_INCREMENT[4] = 0.8
    set thistype.ATTACK_SPEED_INCREMENT[5] = 0.95
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\this.wc3obj")
    call t.Destroy()
endmethod