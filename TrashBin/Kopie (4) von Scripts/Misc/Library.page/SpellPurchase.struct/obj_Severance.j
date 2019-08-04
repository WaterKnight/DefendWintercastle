static ItemType SEVERANCE
    
    
static method Init_obj_Severance takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Severance.wc3item")
    set thistype.SEVERANCE = ItemType.CreateFromSelf('ISev')
    call thistype.SEVERANCE.Classes.Add(ItemClass.SCROLL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Library.page\\SpellPurchase.struct\\Severance.wc3item")
    call t.Destroy()
endmethod