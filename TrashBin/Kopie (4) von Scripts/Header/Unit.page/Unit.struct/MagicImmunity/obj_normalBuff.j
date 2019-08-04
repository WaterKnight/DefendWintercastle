static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.Create('BMaI', "Magic immune", 'bMaI')
    call thistype.NORMAL_BUFF.SetPositive(true)
    call thistype.NORMAL_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAntiMagicShell.blp")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\normalBuff.wc3buff")
    call t.Destroy()
endmethod