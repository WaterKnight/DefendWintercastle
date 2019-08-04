static ItemType SPEAR_OF_THE_DEFENDER
    
    
static method Init_obj_SpearOfTheDefender takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.wc3item")
    set thistype.SPEAR_OF_THE_DEFENDER = ItemType.CreateFromSelf('ISoD')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.wc3item")
    call t.Destroy()
endmethod