static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSDB', "Sleep", 'bSDB')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfClarity.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod