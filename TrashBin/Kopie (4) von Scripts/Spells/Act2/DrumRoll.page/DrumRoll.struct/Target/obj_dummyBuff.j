static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DrumRoll.page\\DrumRoll.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BDrR', "Drum Roll", 'bDrR')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNDrum.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DrumRoll.page\\DrumRoll.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod