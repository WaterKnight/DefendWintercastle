static ItemType SHOP_ITEM
    
    
static method Init_obj_shopItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shopItem.wc3item")
    set thistype.SHOP_ITEM = ItemType.CreateFromSelf('IHoR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\shopItem.wc3item")
    call t.Destroy()
endmethod