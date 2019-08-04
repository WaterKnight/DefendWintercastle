static constant integer DUMMY_BUFF_ID = 'bSil'
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummyBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Silence\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod