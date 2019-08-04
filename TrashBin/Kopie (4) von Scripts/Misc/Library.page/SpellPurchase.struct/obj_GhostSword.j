static ItemType GHOST_SWORD
    
    
static method Init_obj_GhostSword takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\GhostSword.wc3item")
    set thistype.GHOST_SWORD = ItemType.CreateFromSelf('IGhS')
    call thistype.GHOST_SWORD.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\GhostSword.wc3item")
    call t.Destroy()
endmethod