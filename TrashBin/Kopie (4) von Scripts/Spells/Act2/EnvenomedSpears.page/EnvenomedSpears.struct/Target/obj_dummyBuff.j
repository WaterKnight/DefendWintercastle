static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEnS', "Poisoned", 'bEnS')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEnvenomedSpear.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod