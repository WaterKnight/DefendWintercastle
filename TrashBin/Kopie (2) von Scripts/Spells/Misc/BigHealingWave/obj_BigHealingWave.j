static real array DELAY
static string array TARGET_EFFECT_PATH
static string array EFFECT_LIGHTNING_PATH
static real array RESTORED_LIFE_FACTOR
static integer array TARGETS_AMOUNT
static string array EFFECT_LIGHTNING2_PATH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_BigHealingWave takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABHW')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Big Healing Wave")
    call SpellObjectCreation.TEMP.SetOrder("healingwave")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 99999)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 100)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealingWave.blp")
    
    set thistype.DELAY[1] = 0.35
    set thistype.TARGET_EFFECT_PATH[1] = "Spells\\BigHealingWave\\BigHealingWaveTarget.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[1] = "HWPB"
    set thistype.RESTORED_LIFE_FACTOR[1] = 0.75
    set thistype.TARGETS_AMOUNT[1] = 100
    set thistype.EFFECT_LIGHTNING2_PATH[1] = "HWSB"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
endmethod