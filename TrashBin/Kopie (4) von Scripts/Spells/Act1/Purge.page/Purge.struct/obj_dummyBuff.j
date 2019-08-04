static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Purge.page\\Purge.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BPur', "Purge", 'bPur')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPurge.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Purge.page\\Purge.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod