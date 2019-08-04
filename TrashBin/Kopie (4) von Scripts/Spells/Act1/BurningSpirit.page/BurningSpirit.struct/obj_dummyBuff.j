static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\BurningSpirit.page\\BurningSpirit.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBuS', "Burning Spirit", 'bBuS')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\BurningSpirit.page\\BurningSpirit.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod