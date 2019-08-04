static integer array INCREASING_ITEM_TYPES_ID
    
    
static method Init_obj_increasingItemTypes4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[4].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[4].wc3item")
    call t.Destroy()
endmethod