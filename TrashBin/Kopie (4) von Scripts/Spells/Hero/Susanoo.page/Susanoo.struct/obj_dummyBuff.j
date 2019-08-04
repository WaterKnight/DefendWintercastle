static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSuB', "Susanoo", 'bSuB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHowlOfTerror.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Susanoo\\Buff.mdx", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod