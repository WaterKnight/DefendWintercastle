static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Lapidation.page\\Lapidation.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BLap', "Lapidated", 'bLap')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGolemStormBolt.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl", AttachPoint.FOOT_LEFT, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl", AttachPoint.FOOT_RIGHT, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl", AttachPoint.HAND_LEFT, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\Lapidation.page\\Lapidation.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod