static integer array SPEED_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\ChillyBreath.page\\ChillyBreath.struct\\Buff\\this.wc3obj")
    set thistype.SPEED_INCREMENT[1] = -100
    set thistype.SPEED_INCREMENT[2] = -125
    set thistype.SPEED_INCREMENT[3] = -150
    set thistype.SPEED_INCREMENT[4] = -175
    set thistype.SPEED_INCREMENT[5] = -200
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 9
    set thistype.DURATION[3] = 10
    set thistype.DURATION[4] = 11
    set thistype.DURATION[5] = 12
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\ChillyBreath.page\\ChillyBreath.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod