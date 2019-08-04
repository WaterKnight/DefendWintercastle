//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\Spell.struct\obj_parallelCastBuff.j
static constant integer PARALLEL_CAST_BUFF_ID = 'BPar'
    
    
static method Init_obj_parallelCastBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\Spell.struct\\parallelCastBuff.wc3buff")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\Spell.struct\\parallelCastBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\Spell.struct\obj_parallelCastBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_parallelCastBuff)
endmethod