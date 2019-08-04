static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BBat', "Battle Rage", 'bBat')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\BattleRoar\\RoarTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod