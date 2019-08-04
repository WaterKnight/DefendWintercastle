static DestructableType IGLOO
    
    
static method Init_obj_igloo takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\igloo.wc3dest")
    set thistype.IGLOO = DestructableType.Create('C004')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\igloo.wc3dest")
    call t.Destroy()
endmethod