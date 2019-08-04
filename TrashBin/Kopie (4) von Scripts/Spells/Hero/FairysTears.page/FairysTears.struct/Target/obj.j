//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.struct\Target\obj_this.j
static integer array COLD_DURATION
static integer array DAMAGE
static real DAMAGE_DELAY = 0.9
static integer DURATION = 2
static integer DAMAGE_SPELL_POWER_MOD_FACTOR = 1
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\Target\\this.wc3obj")
    set thistype.COLD_DURATION[1] = 1
    set thistype.COLD_DURATION[2] = 2
    set thistype.COLD_DURATION[3] = 3
    set thistype.DAMAGE[1] = 15
    set thistype.DAMAGE[2] = 25
    set thistype.DAMAGE[3] = 35
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.struct\Target\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.struct\Target\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\Starfall\\StarfallTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.struct\Target\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod