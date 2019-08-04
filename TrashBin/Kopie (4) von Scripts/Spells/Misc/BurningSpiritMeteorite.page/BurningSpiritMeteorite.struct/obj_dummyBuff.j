static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBu2', "Burning Spirit", 'bBu2')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\BurningSpiritMeteorite.page\\BurningSpiritMeteorite.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod