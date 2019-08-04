static integer array DAMAGE
static integer array ATTACK_DISABLE_DURATION
static real array DAMAGE_FACTOR
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_BattleRage takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABaR')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Battle Rage")
    call SpellObjectCreation.TEMP.SetOrder("roar")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 450)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 80)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 450)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 15)
    call SpellObjectCreation.TEMP.SetManaCost(2, 92)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 450)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 15)
    call SpellObjectCreation.TEMP.SetManaCost(3, 104)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 450)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 15)
    call SpellObjectCreation.TEMP.SetManaCost(4, 116)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 450)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 15)
    call SpellObjectCreation.TEMP.SetManaCost(5, 128)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FBR0', 5, 'CBR0')
    
    set thistype.DAMAGE[1] = 35
    set thistype.ATTACK_DISABLE_DURATION[1] = 2
    set thistype.DAMAGE_FACTOR[1] = 0.04
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    set thistype.DAMAGE[2] = 45
    set thistype.ATTACK_DISABLE_DURATION[2] = 2
    set thistype.DAMAGE_FACTOR[2] = 0.05
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    set thistype.DAMAGE[3] = 55
    set thistype.ATTACK_DISABLE_DURATION[3] = 2
    set thistype.DAMAGE_FACTOR[3] = 0.06
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    set thistype.DAMAGE[4] = 65
    set thistype.ATTACK_DISABLE_DURATION[4] = 2
    set thistype.DAMAGE_FACTOR[4] = 0.07
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    set thistype.DAMAGE[5] = 75
    set thistype.ATTACK_DISABLE_DURATION[5] = 2
    set thistype.DAMAGE_FACTOR[5] = 0.08
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
endmethod