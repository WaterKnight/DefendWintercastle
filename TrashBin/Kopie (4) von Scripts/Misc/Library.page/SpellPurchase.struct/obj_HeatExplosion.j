static ItemType HEAT_EXPLOSION
    
    
static method Init_obj_HeatExplosion takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\HeatExplosion.wc3item")
    set thistype.HEAT_EXPLOSION = ItemType.CreateFromSelf('IHeE')
    call thistype.HEAT_EXPLOSION.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\HeatExplosion.wc3item")
    call t.Destroy()
endmethod