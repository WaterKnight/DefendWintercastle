//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\SpellShield\obj_normalBuff.j
static Buff NORMAL_BUFF
    
    
static method Init_obj_normalBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\SpellShield\\normalBuff.wc3buff")
    set thistype.NORMAL_BUFF = Buff.Create('BMSP', "Spell Shield", 'bMSP')
    call thistype.NORMAL_BUFF.SetPositive(true)
    call thistype.NORMAL_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp")
    call thistype.NORMAL_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\StaffOfSanctuary\\Staff_Sanctuary_Target.mdl", AttachPoint.CHEST, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MagicImmunity\\SpellShield\\normalBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\MagicImmunity\SpellShield\obj_normalBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_normalBuff)
endmethod