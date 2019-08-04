static real array SPEED_RELATIVE_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\this.wc3obj")
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.25
    set thistype.SPEED_RELATIVE_INCREMENT[2] = 0.35
    set thistype.SPEED_RELATIVE_INCREMENT[3] = 0.4
    set thistype.SPEED_RELATIVE_INCREMENT[4] = 0.45
    set thistype.SPEED_RELATIVE_INCREMENT[5] = 0.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\this.wc3obj")
    call t.Destroy()
endmethod