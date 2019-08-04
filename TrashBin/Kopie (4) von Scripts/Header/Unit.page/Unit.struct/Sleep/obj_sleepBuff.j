static constant integer SLEEP_BUFF_ID = 'BUsl'
    
    
static method Init_obj_sleepBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Sleep\\sleepBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Sleep\\sleepBuff.wc3buff")
    call t.Destroy()
endmethod