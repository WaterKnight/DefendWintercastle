static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BTrR', "Tropical Rainbow", 'bTrR')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSnazzyPotion.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerChange.mdl", AttachPoint.HEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Tavern.page\\Tavern.struct\\TropicalRainbow.page\\TropicalRainbow.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod