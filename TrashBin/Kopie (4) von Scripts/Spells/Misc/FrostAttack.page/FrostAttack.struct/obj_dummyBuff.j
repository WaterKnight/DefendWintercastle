static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FrostAttack.page\\FrostAttack.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FrostAttack.page\\FrostAttack.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod