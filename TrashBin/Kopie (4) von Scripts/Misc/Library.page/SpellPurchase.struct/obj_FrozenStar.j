static ItemType FROZEN_STAR
    
    
static method Init_obj_FrozenStar takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\FrozenStar.wc3item")
    set thistype.FROZEN_STAR = ItemType.CreateFromSelf('IFrS')
    call thistype.FROZEN_STAR.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\FrozenStar.wc3item")
    call t.Destroy()
endmethod