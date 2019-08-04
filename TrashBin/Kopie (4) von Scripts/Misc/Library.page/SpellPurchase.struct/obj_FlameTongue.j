static ItemType FLAME_TONGUE
    
    
static method Init_obj_FlameTongue takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\FlameTongue.wc3item")
    set thistype.FLAME_TONGUE = ItemType.CreateFromSelf('IFlT')
    call thistype.FLAME_TONGUE.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\FlameTongue.wc3item")
    call t.Destroy()
endmethod