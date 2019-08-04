static ItemType SNOWY_SPHERE
    
    
static method Init_obj_SnowySphere takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\SnowySphere.wc3item")
    set thistype.SNOWY_SPHERE = ItemType.CreateFromSelf('ISnS')
    call thistype.SNOWY_SPHERE.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\SnowySphere.wc3item")
    call t.Destroy()
endmethod