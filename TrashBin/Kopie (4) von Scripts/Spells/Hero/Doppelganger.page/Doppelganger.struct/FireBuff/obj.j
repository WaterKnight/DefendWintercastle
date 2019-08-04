//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\FireBuff\obj_this.j
static integer array DURATION
static integer array AREA_RANGE
static real array DAMAGE_FACTOR
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\this.wc3obj")
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 30
    set thistype.DURATION[3] = 30
    set thistype.AREA_RANGE[1] = 125
    set thistype.AREA_RANGE[2] = 140
    set thistype.AREA_RANGE[3] = 160
    set thistype.DAMAGE_FACTOR[1] = 0.3
    set thistype.DAMAGE_FACTOR[2] = 0.5
    set thistype.DAMAGE_FACTOR[3] = 0.7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\FireBuff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\FireBuff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BDGF', "Fire Buff", 'bDGF')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFire.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIfb\\AIfbTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\FireBuff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\FireBuff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod