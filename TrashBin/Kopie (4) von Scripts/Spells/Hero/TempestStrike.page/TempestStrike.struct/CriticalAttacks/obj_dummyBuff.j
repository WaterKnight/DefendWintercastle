static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrA', "Tempest Strike", 'bCrA')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCleavingAttack.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\TempestStrike\\Buff.mdx", AttachPoint.WEAPON, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\CriticalAttacks\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod