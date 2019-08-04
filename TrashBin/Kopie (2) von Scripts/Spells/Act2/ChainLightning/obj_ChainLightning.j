static string array TARGET_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static string array EFFECT_LIGHTNING_PATH
static integer array TARGETS_AMOUNT
static real array DAMAGE_REDUCTION_FACTOR
static string array EFFECT_LIGHTNING2_PATH
static integer array DAMAGE
    
static method Init_obj_ChainLightning takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AChL')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Chain Lightning")
    call SpellObjectCreation.TEMP.SetOrder("chainlightning")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 95)
    call SpellObjectCreation.TEMP.SetRange(1, 550)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp")
    
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[1] = "CLPB"
    set thistype.TARGETS_AMOUNT[1] = 6
    set thistype.DAMAGE_REDUCTION_FACTOR[1] = 0.1
    set thistype.EFFECT_LIGHTNING2_PATH[1] = "CLSB"
    set thistype.DAMAGE[1] = 120
endmethod