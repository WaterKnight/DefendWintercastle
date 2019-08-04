static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BHoN', "Hand of Nature", 'bHoN')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod