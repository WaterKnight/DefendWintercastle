//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BRVA', "Discovered", 'bRVA')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeal.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\Target\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\Target\obj_this.j
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\RevealAura.page\\RevealAura.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.struct\Target\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod