static ItemType ICE_TEA
    
    
static method Init_obj_IceTea takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\IceTea.wc3item")
    set thistype.ICE_TEA = ItemType.CreateFromSelf('IIcT')
    call thistype.ICE_TEA.ChargesAmount.Set(1)
    call thistype.ICE_TEA.Abilities.AddWithLevel(IceTea(NULL).THIS_SPELL, 2)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\IceTea.wc3item")
    call t.Destroy()
endmethod