static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Cold\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCol', "Cold", 'bCol')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrost.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\FrostDamage\\FrostDamage.mdl", AttachPoint.CHEST, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Cold\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod