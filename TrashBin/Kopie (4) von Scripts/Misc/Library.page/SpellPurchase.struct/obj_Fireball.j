static ItemType FIREBALL
    
    
static method Init_obj_Fireball takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Fireball.wc3item")
    set thistype.FIREBALL = ItemType.CreateFromSelf('IFiB')
    call thistype.FIREBALL.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Fireball.wc3item")
    call t.Destroy()
endmethod