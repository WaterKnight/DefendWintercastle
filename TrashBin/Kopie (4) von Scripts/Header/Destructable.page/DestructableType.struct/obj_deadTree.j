static DestructableType DEAD_TREE
    
    
static method Init_obj_deadTree takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\deadTree.wc3dest")
    set thistype.DEAD_TREE = DestructableType.Create('C001')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\deadTree.wc3dest")
    call t.Destroy()
endmethod