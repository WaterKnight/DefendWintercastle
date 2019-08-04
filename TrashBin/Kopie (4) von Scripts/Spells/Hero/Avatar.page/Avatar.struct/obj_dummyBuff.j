static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BAva', "Avatar", 'bAva')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvatar.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Avatar.page\\Avatar.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod