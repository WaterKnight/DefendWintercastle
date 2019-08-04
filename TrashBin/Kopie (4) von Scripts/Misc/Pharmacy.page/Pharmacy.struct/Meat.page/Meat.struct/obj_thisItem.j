static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\Meat.page\\Meat.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IMea')
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(Meat(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\Meat.page\\Meat.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod