static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\LiquidFire\\Liquidfire.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Voodoo\\VoodooAura.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Amaterasu.page\\Amaterasu.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod