static ItemType BLIZZARD
    
    
static method Init_obj_Blizzard takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Blizzard.wc3item")
    set thistype.BLIZZARD = ItemType.CreateFromSelf('IBlz')
    call thistype.BLIZZARD.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Blizzard.wc3item")
    call t.Destroy()
endmethod