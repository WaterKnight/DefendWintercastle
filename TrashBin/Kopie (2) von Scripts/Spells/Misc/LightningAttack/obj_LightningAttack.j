static string array EFFECT_LIGHTNING_PATH
static real array DAMAGE_REDUCTION_FACTOR
static string array TARGET_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static integer array STUN_TARGETS_AMOUNT
static real array STUN_DURATION
static integer array TARGETS_AMOUNT
static string array EFFECT_LIGHTNING2_PATH
static integer array DAMAGE
    
static method Init_obj_LightningAttack takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ALiA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(6)
    call SpellObjectCreation.TEMP.SetName("Lightning Attack")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 500)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 500)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 500)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 500)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(6, 500)
    call SpellObjectCreation.TEMP.SetCastTime(6, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(6, 0)
    call SpellObjectCreation.TEMP.SetCooldown(6, 0)
    call SpellObjectCreation.TEMP.SetManaCost(6, 0)
    call SpellObjectCreation.TEMP.SetRange(6, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp")
    
    set thistype.EFFECT_LIGHTNING_PATH[1] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[1] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[1] = 2
    set thistype.STUN_DURATION[1] = 1.25
    set thistype.TARGETS_AMOUNT[1] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[1] = "CLSB"
    set thistype.DAMAGE[1] = 20
    set thistype.EFFECT_LIGHTNING_PATH[2] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[2] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[2] = 3
    set thistype.STUN_DURATION[2] = 1.25
    set thistype.TARGETS_AMOUNT[2] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[2] = "CLSB"
    set thistype.DAMAGE[2] = 35
    set thistype.EFFECT_LIGHTNING_PATH[3] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[3] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[3] = 3
    set thistype.STUN_DURATION[3] = 1.25
    set thistype.TARGETS_AMOUNT[3] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[3] = "CLSB"
    set thistype.DAMAGE[3] = 50
    set thistype.EFFECT_LIGHTNING_PATH[4] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[4] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[4] = 4
    set thistype.STUN_DURATION[4] = 1.25
    set thistype.TARGETS_AMOUNT[4] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[4] = "CLSB"
    set thistype.DAMAGE[4] = 65
    set thistype.EFFECT_LIGHTNING_PATH[5] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[5] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[5] = 4
    set thistype.STUN_DURATION[5] = 1.25
    set thistype.TARGETS_AMOUNT[5] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[5] = "CLSB"
    set thistype.DAMAGE[5] = 80
    set thistype.EFFECT_LIGHTNING_PATH[6] = "CLPB"
    set thistype.DAMAGE_REDUCTION_FACTOR[6] = 0.2
    set thistype.TARGET_EFFECT_ATTACH_POINT[6] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[6] = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
    set thistype.STUN_TARGETS_AMOUNT[6] = 5
    set thistype.STUN_DURATION[6] = 1.25
    set thistype.TARGETS_AMOUNT[6] = 10
    set thistype.EFFECT_LIGHTNING2_PATH[6] = "CLSB"
    set thistype.DAMAGE[6] = 95
endmethod