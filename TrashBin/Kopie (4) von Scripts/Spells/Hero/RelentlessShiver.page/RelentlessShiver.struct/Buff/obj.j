//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_summonBuff.j
static Buff SUMMON_BUFF
    
    
static method Init_obj_summonBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\summonBuff.wc3buff")
    set thistype.SUMMON_BUFF = Buff.Create('BDRS', "Awakened", 'bDRS')
    call thistype.SUMMON_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\summonBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_summonBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_this.j
static integer array SUMMON_DURATION
static string SUMMON_EFFECT_PATH = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
static integer array DURATION
static string SUMMON_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string SUMMON_DEATH_EFFECT_PATH = "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\this.wc3obj")
    set thistype.SUMMON_DURATION[1] = 30
    set thistype.SUMMON_DURATION[2] = 30
    set thistype.SUMMON_DURATION[3] = 30
    set thistype.DURATION[1] = 4
    set thistype.DURATION[2] = 5
    set thistype.DURATION[3] = 6
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BDRB', "Relentless Shiver", 'bDRB')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_summonBuff)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod