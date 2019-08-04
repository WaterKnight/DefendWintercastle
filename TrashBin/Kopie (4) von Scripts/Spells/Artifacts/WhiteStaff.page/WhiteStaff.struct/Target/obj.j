//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\Target\obj_this.j
static integer array EVASION_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\this.wc3obj")
    set thistype.EVASION_INCREMENT[1] = 30
    set thistype.EVASION_INCREMENT[2] = 40
    set thistype.EVASION_INCREMENT[3] = 50
    set thistype.EVASION_INCREMENT[4] = 60
    set thistype.EVASION_INCREMENT[5] = 70
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\Target\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BWhS', "White Staff", 'bWhS')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheMoon.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\WhiteStaff.page\\WhiteStaff.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\Target\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod