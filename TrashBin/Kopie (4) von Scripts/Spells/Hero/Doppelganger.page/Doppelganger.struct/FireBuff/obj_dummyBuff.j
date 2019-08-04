static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BDGF', "Fire Buff", 'bDGF')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFire.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIfb\\AIfbTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod