static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BHeO', "Herbal Ointment", 'bHeO')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealingSalve.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\HerbalOintment.page\\HerbalOintment.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod