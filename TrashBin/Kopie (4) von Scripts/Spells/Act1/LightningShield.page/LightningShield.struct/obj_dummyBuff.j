static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BLiS', "Lightning Shield", 'bLiS')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod