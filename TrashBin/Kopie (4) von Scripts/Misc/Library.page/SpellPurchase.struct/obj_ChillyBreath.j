static ItemType CHILLY_BREATH
    
    
static method Init_obj_ChillyBreath takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\ChillyBreath.wc3item")
    set thistype.CHILLY_BREATH = ItemType.CreateFromSelf('IChB')
    call thistype.CHILLY_BREATH.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\ChillyBreath.wc3item")
    call t.Destroy()
endmethod