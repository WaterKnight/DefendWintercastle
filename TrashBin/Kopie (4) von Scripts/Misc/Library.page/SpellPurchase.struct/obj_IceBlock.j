static ItemType ICE_BLOCK
    
    
static method Init_obj_IceBlock takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\IceBlock.wc3item")
    set thistype.ICE_BLOCK = ItemType.CreateFromSelf('IIcB')
    call thistype.ICE_BLOCK.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\IceBlock.wc3item")
    call t.Destroy()
endmethod