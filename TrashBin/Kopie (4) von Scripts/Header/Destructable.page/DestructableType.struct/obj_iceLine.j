static DestructableType ICE_LINE
    
    
static method Init_obj_iceLine takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\iceLine.wc3dest")
    set thistype.ICE_LINE = DestructableType.Create('C002')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Destructable.page\\DestructableType.struct\\iceLine.wc3dest")
    call t.Destroy()
endmethod