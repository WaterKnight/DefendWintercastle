//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.struct\Buff\obj_this.j
static integer array MANA_INCREMENT
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
static integer array SPELL_POWER_INCREMENT
static integer array DURATION
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real array ATTACK_SPEED_INCREMENT
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\this.wc3obj")
    set thistype.MANA_INCREMENT[1] = 25
    set thistype.MANA_INCREMENT[2] = 35
    set thistype.MANA_INCREMENT[3] = 45
    set thistype.MANA_INCREMENT[4] = 55
    set thistype.MANA_INCREMENT[5] = 60
    set thistype.SPELL_POWER_INCREMENT[1] = 15
    set thistype.SPELL_POWER_INCREMENT[2] = 25
    set thistype.SPELL_POWER_INCREMENT[3] = 35
    set thistype.SPELL_POWER_INCREMENT[4] = 45
    set thistype.SPELL_POWER_INCREMENT[5] = 55
    set thistype.DURATION[1] = 9
    set thistype.DURATION[2] = 9
    set thistype.DURATION[3] = 9
    set thistype.DURATION[4] = 9
    set thistype.DURATION[5] = 9
    set thistype.ATTACK_SPEED_INCREMENT[1] = 0.1
    set thistype.ATTACK_SPEED_INCREMENT[2] = 0.15
    set thistype.ATTACK_SPEED_INCREMENT[3] = 0.2
    set thistype.ATTACK_SPEED_INCREMENT[4] = 0.25
    set thistype.ATTACK_SPEED_INCREMENT[5] = 0.3
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.struct\Buff\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.struct\Buff\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BCrM', "Spell Potion", 'bCrM')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMinorRejuvPotion.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Human\\MagicSentry\\MagicSentryCaster.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\MagicBottle.page\\MagicBottle.struct\\Buff\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.struct\Buff\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod