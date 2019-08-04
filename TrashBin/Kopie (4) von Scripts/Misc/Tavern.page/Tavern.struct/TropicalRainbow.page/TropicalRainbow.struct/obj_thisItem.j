static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('ITrR')
    call thistype.THIS_ITEM.Classes.Add(ItemClass.POWER_UP)
    call thistype.THIS_ITEM.ChargesAmount.Set(1)
    call thistype.THIS_ITEM.Abilities.Add(TropicalRainbow(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod