static Buff NONE_BUFF
    
    
static method Init_obj_noneBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\noneBuff.wc3buff")
    set thistype.NONE_BUFF = Buff.CreateHidden(thistype.NAME + " (noneBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\noneBuff.wc3buff")
    call t.Destroy()
endmethod