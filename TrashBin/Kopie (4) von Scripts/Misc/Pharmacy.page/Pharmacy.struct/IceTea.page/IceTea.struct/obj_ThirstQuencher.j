static ItemType THIRST_QUENCHER
    
    
static method Init_obj_ThirstQuencher takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\ThirstQuencher.wc3item")
    set thistype.THIRST_QUENCHER = ItemType.CreateFromSelf('IThQ')
    call thistype.THIRST_QUENCHER.ChargesAmount.Set(1)
    call thistype.THIRST_QUENCHER.Abilities.AddWithLevel(IceTea(NULL).THIS_SPELL, 3)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\IceTea.page\\IceTea.struct\\ThirstQuencher.wc3item")
    call t.Destroy()
endmethod