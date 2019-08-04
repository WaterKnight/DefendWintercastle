static DestructableType BARREL
    
    
static method Init_obj_barrel takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\barrel.wc3dest")
    set thistype.BARREL = DestructableType.Create('C005')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\barrel.wc3dest")
    call t.Destroy()
endmethod