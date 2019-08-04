static DestructableType EMPTY
    
    
static method Init_obj_empty takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\empty.wc3dest")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\empty.wc3dest")
    call t.Destroy()
endmethod