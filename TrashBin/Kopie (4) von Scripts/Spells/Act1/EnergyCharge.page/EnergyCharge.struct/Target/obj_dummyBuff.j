static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEnC', "Energy Charge", 'bEnC')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSeaGiantPulverize.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\GreenDragonMissile\\GreenDragonMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\EnergyCharge.page\\EnergyCharge.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod