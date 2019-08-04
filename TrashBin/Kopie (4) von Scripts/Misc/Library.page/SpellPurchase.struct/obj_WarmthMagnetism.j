static ItemType WARMTH_MAGNETISM
    
    
static method Init_obj_WarmthMagnetism takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\WarmthMagnetism.wc3item")
    set thistype.WARMTH_MAGNETISM = ItemType.CreateFromSelf('IWaM')
    call thistype.WARMTH_MAGNETISM.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\WarmthMagnetism.wc3item")
    call t.Destroy()
endmethod