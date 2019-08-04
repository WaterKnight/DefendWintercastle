static Buff TIMED_BUFF
    
    
static method Init_obj_timedBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Invisibility\\timedBuff.wc3buff")
    set thistype.TIMED_BUFF = Buff.CreateHidden(thistype.NAME + " (timedBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Invisibility\\timedBuff.wc3buff")
    call t.Destroy()
endmethod