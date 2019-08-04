static DestructableType TREE11_WITH_SHADOW
    
    
static method Init_obj_tree11WithShadow takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\tree11WithShadow.wc3dest")
    set thistype.TREE11_WITH_SHADOW = DestructableType.Create('C00C')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\tree11WithShadow.wc3dest")
    call t.Destroy()
endmethod