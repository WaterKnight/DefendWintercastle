static constant integer DUMMY_UNIT_ID = 'qEWS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Effect.page\\SpotEffectWithSize.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Effect.page\\SpotEffectWithSize.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod