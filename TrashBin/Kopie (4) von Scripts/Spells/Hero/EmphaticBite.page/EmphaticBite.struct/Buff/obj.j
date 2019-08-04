//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\Buff\obj_this.j
static integer array DAMAGE_INCREMENT
static integer array DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\this.wc3obj")
    set thistype.DAMAGE_INCREMENT[1] = 15
    set thistype.DAMAGE_INCREMENT[2] = 25
    set thistype.DAMAGE_INCREMENT[3] = 35
    set thistype.DAMAGE_INCREMENT[4] = 45
    set thistype.DAMAGE_INCREMENT[5] = 55
    set thistype.DURATION[1] = 8
    set thistype.DURATION[2] = 8
    set thistype.DURATION[3] = 8
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 8
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\Buff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BEmB', "Emphatic Bite", 'bEmB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCannibalize.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\Buff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod