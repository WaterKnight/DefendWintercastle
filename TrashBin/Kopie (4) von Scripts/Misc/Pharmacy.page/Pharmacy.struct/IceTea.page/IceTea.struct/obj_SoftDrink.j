static ItemType SOFT_DRINK
    
    
static method Init_obj_SoftDrink takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\SoftDrink.wc3item")
    set thistype.SOFT_DRINK = ItemType.CreateFromSelf('ISDr')
    call thistype.SOFT_DRINK.ChargesAmount.Set(1)
    call thistype.SOFT_DRINK.Abilities.Add(IceTea(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\SoftDrink.wc3item")
    call t.Destroy()
endmethod