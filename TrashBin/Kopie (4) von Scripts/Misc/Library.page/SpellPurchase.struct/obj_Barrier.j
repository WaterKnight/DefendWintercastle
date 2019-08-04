static ItemType BARRIER
    
    
static method Init_obj_Barrier takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Barrier.wc3item")
    set thistype.BARRIER = ItemType.CreateFromSelf('IBar')
    call thistype.BARRIER.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Barrier.wc3item")
    call t.Destroy()
endmethod