static integer array DAMAGE_PER_BUFF
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\this.wc3obj")
    set thistype.DAMAGE_PER_BUFF[1] = 20
    set thistype.DAMAGE_PER_BUFF[2] = 30
    set thistype.DAMAGE_PER_BUFF[3] = 40
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\this.wc3obj")
    call t.Destroy()
endmethod