static DestructableType PAVEMENT
    
    
static method Init_obj_pavement takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\pavement.wc3dest")
    set thistype.PAVEMENT = DestructableType.Create('C00F')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\pavement.wc3dest")
    call t.Destroy()
endmethod