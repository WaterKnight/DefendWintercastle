static constant integer Z_ENABLER_UNIT_ID = 'qFly'
    
    
static method Init_obj_zEnablerUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerUnit.wc3unit")
    call t.Destroy()
endmethod