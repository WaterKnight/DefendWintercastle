static constant integer PARALLEL_CAST_BUFF_ID = 'BPar'
    
    
static method Init_obj_parallelCastBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\Spell.struct\\parallelCastBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\Spell.struct\\parallelCastBuff.wc3buff")
    call t.Destroy()
endmethod