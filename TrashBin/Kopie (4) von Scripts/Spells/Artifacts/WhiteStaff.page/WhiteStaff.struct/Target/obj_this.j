static integer array EVASION_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\this.wc3obj")
    set thistype.EVASION_INCREMENT[1] = 30
    set thistype.EVASION_INCREMENT[2] = 40
    set thistype.EVASION_INCREMENT[3] = 50
    set thistype.EVASION_INCREMENT[4] = 60
    set thistype.EVASION_INCREMENT[5] = 70
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod