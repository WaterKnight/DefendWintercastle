//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\obj_normalBuff.j
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
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\obj_normalBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\obj_noneBuff.j
static Buff NONE_BUFF
    
    
static method Init_obj_noneBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\noneBuff.wc3buff")
    set thistype.NONE_BUFF = Buff.CreateHidden(thistype.NAME + " (noneBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\noneBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\obj_noneBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_normalBuff)
    call Buff.AddInit(function thistype.Init_obj_noneBuff)
endmethod