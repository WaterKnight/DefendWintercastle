static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EmergencyProvisions.page\\EmergencyProvisions.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IEmP')
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(EmergencyProvisions(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\EmergencyProvisions.page\\EmergencyProvisions.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod