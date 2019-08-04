static ItemType THIS_ITEM_TYPE
    
    
static method Init_obj_thisItemType takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\thisItemType.wc3item")
    set thistype.THIS_ITEM_TYPE = ItemType.CreateFromSelf('ILum')
    call thistype.THIS_ITEM_TYPE.Classes.Add(ItemClass.POWER_UP)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Lumber.page\\Lumber.struct\\thisItemType.wc3item")
    call t.Destroy()
endmethod