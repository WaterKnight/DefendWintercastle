static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSoP', "Poisoned", 'bSoP')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPoisonSting.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod