static DestructableType TREE_WITH_SHADOW
    
    
static method Init_obj_treeWithShadow takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\treeWithShadow.wc3dest")
    set thistype.TREE_WITH_SHADOW = DestructableType.Create('C000')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\treeWithShadow.wc3dest")
    call t.Destroy()
endmethod