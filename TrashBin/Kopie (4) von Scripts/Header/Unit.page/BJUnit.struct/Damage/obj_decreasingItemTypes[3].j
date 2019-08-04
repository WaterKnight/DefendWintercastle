static integer array DECREASING_ITEM_TYPES_ID
    
    
static method Init_obj_decreasingItemTypes3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[3].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[3].wc3item")
    call t.Destroy()
endmethod