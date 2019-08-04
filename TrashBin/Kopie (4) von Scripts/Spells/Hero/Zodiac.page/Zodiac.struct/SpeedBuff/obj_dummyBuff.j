static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BZBS', "Zodiac", 'bZBS')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRacoon.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Units\\NightElf\\Owl\\Owl.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\SpeedBuff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod