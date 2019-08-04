static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BInf', "Infection", 'bInf')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Infection\\Caster.mdx", AttachPoint.HEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod