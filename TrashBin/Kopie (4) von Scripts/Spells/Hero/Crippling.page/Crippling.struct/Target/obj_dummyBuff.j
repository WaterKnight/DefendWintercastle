static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrp', "Crippled", 'bCrp')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Crippling\\Target.mdx", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod