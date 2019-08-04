static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Boost.page\\Boost.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBoo', "Boost", 'bBoo')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEtherealFormOn.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Boost\\Buff.mdx", AttachPoint.FOOT, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Boost.page\\Boost.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod