
static method Init_obj_dummyBuff3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[3].wc3buff")
    set thistype.DUMMY_BUFF[3] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[3].SetPositive(true)
    call thistype.DUMMY_BUFF[3].SetIcon("Spells\\DeprivingShock\\BTNBuff3.blp")
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[3].wc3buff")
    call t.Destroy()
endmethod