static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\Revert\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\Barkskin\\BarkSkinTarget.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\Barkskin\\BarkSkinTarget.mdl", AttachPoint.HAND_RIGHT, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\Revert\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod