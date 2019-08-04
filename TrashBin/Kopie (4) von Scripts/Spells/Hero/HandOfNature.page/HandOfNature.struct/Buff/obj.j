//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Buff\obj_this.j
static integer array DAMAGE
static real INTERVAL = 0.5
static integer array EVASION_INCREMENT
static real array DURATION
static integer array HERO_DURATION
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\this.wc3obj")
    set thistype.DAMAGE[1] = 40
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 40
    set thistype.DAMAGE[4] = 40
    set thistype.DAMAGE[5] = 40
    set thistype.EVASION_INCREMENT[1] = -40
    set thistype.EVASION_INCREMENT[2] = -50
    set thistype.EVASION_INCREMENT[3] = -60
    set thistype.EVASION_INCREMENT[4] = -70
    set thistype.EVASION_INCREMENT[5] = -80
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 3.5
    set thistype.DURATION[3] = 4
    set thistype.DURATION[4] = 4.5
    set thistype.DURATION[5] = 5
    set thistype.HERO_DURATION[1] = 1
    set thistype.HERO_DURATION[2] = 1
    set thistype.HERO_DURATION[3] = 1
    set thistype.HERO_DURATION[4] = 1
    set thistype.HERO_DURATION[5] = 1
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Buff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BHoN', "Hand of Nature", 'bHoN')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Buff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod