//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[2].j

static method Init_obj_dummyBuff2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[2].wc3buff")
    set thistype.DUMMY_BUFF[2] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[2].SetPositive(true)
    call thistype.DUMMY_BUFF[2].SetIcon("Spells\\DeprivingShock\\BTNBuff2.blp")
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[2].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[2].wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_this.j
static integer array DURATION
static integer array EVASION_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\this.wc3obj")
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 8
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 8
    set thistype.EVASION_INCREMENT[1] = 35
    set thistype.EVASION_INCREMENT[2] = 60
    set thistype.EVASION_INCREMENT[3] = 85
    set thistype.EVASION_INCREMENT[4] = 110
    set thistype.EVASION_INCREMENT[5] = 135
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[3].j

static method Init_obj_dummyBuff3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[3].wc3buff")
    set thistype.DUMMY_BUFF[3] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[3].SetPositive(true)
    call thistype.DUMMY_BUFF[3].SetIcon("Spells\\DeprivingShock\\BTNBuff3.blp")
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[3].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[3].wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[1].j
static Buff array DUMMY_BUFF
    
    
static method Init_obj_dummyBuff1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[1].wc3buff")
    set thistype.DUMMY_BUFF[1] = Buff.Create('BDeS', "Depriving Shock", 'bDeS')
    call thistype.DUMMY_BUFF[1].SetPositive(true)
    call thistype.DUMMY_BUFF[1].SetIcon("ReplaceableTextures\\CommandButtons\\BTNRavenForm.blp")
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call thistype.DUMMY_BUFF[1].TargetEffects.Add("Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\DeprivingShock.page\\DeprivingShock.struct\\Buff\\dummyBuff[1].wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff\obj_dummyBuff[1].j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff2)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff3)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff1)
endmethod