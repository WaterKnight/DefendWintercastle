
static method Init_obj_dummyBuff2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[2].wc3buff")
    set thistype.DUMMY_BUFF[2] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[2].SetPositive(true)
    call thistype.DUMMY_BUFF[2].SetIcon("Spells\\DeprivingShock\\BTNBuff2.blp")
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[2].wc3buff")
    call t.Destroy()
endmethod