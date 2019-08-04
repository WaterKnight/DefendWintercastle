//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\CreepBuffs\MarkOfThePaw.page\MarkOfThePaw.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\CreepBuffs\\MarkOfThePaw.page\\MarkOfThePaw.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BMOP', "Mark of the Paw", 'bMOP')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\BattleRoar\\RoarTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\CreepBuffs\\MarkOfThePaw.page\\MarkOfThePaw.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\CreepBuffs\MarkOfThePaw.page\MarkOfThePaw.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod