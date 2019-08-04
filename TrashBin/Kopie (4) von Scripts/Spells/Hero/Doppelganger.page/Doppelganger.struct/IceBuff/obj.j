//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\IceBuff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BDGC', "Cold Buff", 'bDGC')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrost.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Items\\AIob\\AIobTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\IceBuff\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\IceBuff\obj_this.j
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\this.wc3obj")
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 4
    set thistype.DURATION[3] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\IceBuff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\IceBuff\obj_this.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod