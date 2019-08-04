static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Eclipse\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEcl', "Eclipse", 'bEcl')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Other\\Eclipse\\Target.mdx", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Eclipse\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod