static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.page\\SpearOfTheDefender.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSoD', "Bleeding", 'bSoD')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\SpearOfTheDefender.page\\SpearOfTheDefender.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod