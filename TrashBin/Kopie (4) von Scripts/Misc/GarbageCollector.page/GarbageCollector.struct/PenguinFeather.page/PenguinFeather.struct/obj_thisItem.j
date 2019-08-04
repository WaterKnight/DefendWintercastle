static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IPeF')
    call thistype.THIS_ITEM.Abilities.Add(PenguinFeather(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\PenguinFeather.page\\PenguinFeather.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod