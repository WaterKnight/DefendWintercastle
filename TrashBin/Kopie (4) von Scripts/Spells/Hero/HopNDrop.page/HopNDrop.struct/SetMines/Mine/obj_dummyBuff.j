static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSMB', "Mine", 'bSMB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGoblinLandMine.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("units\\human\\phoenix\\phoenix.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HopNDrop.page\\HopNDrop.struct\\SetMines\\Mine\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod