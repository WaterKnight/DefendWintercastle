//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\Buff\obj_this.j
static real INTERVAL = 0.35
static integer DURATION = 15
static integer DAMAGE_PER_SECOND = 30
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\Buff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BFiW', "Fire Water", 'bFiW')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGreaterInvulneralbility.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedTarget.mdl", AttachPoint.CHEST, EffectLevel.LOW)
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\Pharmacy.page\Pharmacy.struct\FireWater.page\FireWater.struct\Buff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod