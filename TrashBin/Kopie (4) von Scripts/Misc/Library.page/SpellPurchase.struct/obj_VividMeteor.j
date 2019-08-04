static ItemType VIVID_METEOR
    
    
static method Init_obj_VividMeteor takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\VividMeteor.wc3item")
    set thistype.VIVID_METEOR = ItemType.CreateFromSelf('IViM')
    call thistype.VIVID_METEOR.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\VividMeteor.wc3item")
    call t.Destroy()
endmethod