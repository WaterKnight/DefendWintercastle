static ItemType EMPTY
    
    
static method Init_obj_empty takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\ItemType.page\\ItemType.struct\\empty.wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\ItemType.page\\ItemType.struct\\empty.wc3item")
    call t.Destroy()
endmethod