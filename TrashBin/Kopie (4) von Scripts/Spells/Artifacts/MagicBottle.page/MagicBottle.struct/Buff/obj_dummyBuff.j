static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrM', "Spell Potion", 'bCrM')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMinorRejuvPotion.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\MagicSentry\\MagicSentryCaster.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod