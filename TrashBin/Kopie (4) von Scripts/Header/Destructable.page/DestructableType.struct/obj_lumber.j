static DestructableType LUMBER
    
    
static method Init_obj_lumber takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\lumber.wc3dest")
    set thistype.LUMBER = DestructableType.Create('C00H')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\lumber.wc3dest")
    call t.Destroy()
endmethod