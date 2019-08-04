static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GoldCoin.page\\GoldCoin.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('ICoi')
    call thistype.THIS_ITEM.Classes.Add(ItemClass.POWER_UP)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GoldCoin.page\\GoldCoin.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod