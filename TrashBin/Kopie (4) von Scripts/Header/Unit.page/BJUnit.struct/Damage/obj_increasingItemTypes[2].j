
static method Init_obj_increasingItemTypes2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[2].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[2].wc3item")
    call t.Destroy()
endmethod