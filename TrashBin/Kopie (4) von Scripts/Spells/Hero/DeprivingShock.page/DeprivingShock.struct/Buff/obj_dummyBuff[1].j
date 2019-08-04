static Buff array DUMMY_BUFF
    
    
static method Init_obj_dummyBuff1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[1].wc3buff")
    set thistype.DUMMY_BUFF[1] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[1].SetPositive(true)
    call thistype.DUMMY_BUFF[1].SetIcon("ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[1].wc3buff")
    call t.Destroy()
endmethod