static integer array MAX_DAMAGE
static real array HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR
static string array SPECIAL_EFFECT_PATH
static real array DAMAGE_IGNITE_BONUS
static integer array MAX_LENGTH
static string array SPECIAL_EFFECT2_PATH
static integer array DAMAGE_DAMAGE_MOD_FACTOR
static integer array SPEED
static integer array HORIZONTAL_MAX_WIDTH
static real array INTERVAL
static integer array DAMAGE
    
static method Init_obj_FlameTongue takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFlT')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Flame Tongue")
    call SpellObjectCreation.TEMP.SetOrder("clusterrockets")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 200)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 200)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 45)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 10)
    call SpellObjectCreation.TEMP.SetManaCost(3, 55)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 200)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 10)
    call SpellObjectCreation.TEMP.SetManaCost(4, 70)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 200)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 10)
    call SpellObjectCreation.TEMP.SetManaCost(5, 90)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMarkOfFire.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FFT0', 5, 'CFT0')
    
    set thistype.MAX_DAMAGE[1] = 500
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[1] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    set thistype.DAMAGE_IGNITE_BONUS[1] = 0.5
    set thistype.MAX_LENGTH[1] = 600
    set thistype.SPECIAL_EFFECT2_PATH[1] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[1] = 1
    set thistype.SPEED[1] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[1] = 500
    set thistype.INTERVAL[1] = 0.2
    set thistype.DAMAGE[1] = 35
    set thistype.MAX_DAMAGE[2] = 900
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[2] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    set thistype.DAMAGE_IGNITE_BONUS[2] = 0.6
    set thistype.MAX_LENGTH[2] = 600
    set thistype.SPECIAL_EFFECT2_PATH[2] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[2] = 1
    set thistype.SPEED[2] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[2] = 500
    set thistype.INTERVAL[2] = 0.2
    set thistype.DAMAGE[2] = 50
    set thistype.MAX_DAMAGE[3] = 1500
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[3] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    set thistype.DAMAGE_IGNITE_BONUS[3] = 0.7
    set thistype.MAX_LENGTH[3] = 600
    set thistype.SPECIAL_EFFECT2_PATH[3] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[3] = 1
    set thistype.SPEED[3] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[3] = 500
    set thistype.INTERVAL[3] = 0.2
    set thistype.DAMAGE[3] = 65
    set thistype.MAX_DAMAGE[4] = 2200
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[4] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    set thistype.DAMAGE_IGNITE_BONUS[4] = 0.8
    set thistype.MAX_LENGTH[4] = 600
    set thistype.SPECIAL_EFFECT2_PATH[4] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[4] = 1
    set thistype.SPEED[4] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[4] = 500
    set thistype.INTERVAL[4] = 0.2
    set thistype.DAMAGE[4] = 80
    set thistype.MAX_DAMAGE[5] = 3000
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[5] = 0.5
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    set thistype.DAMAGE_IGNITE_BONUS[5] = 0.9
    set thistype.MAX_LENGTH[5] = 600
    set thistype.SPECIAL_EFFECT2_PATH[5] = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[5] = 1
    set thistype.SPEED[5] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[5] = 500
    set thistype.INTERVAL[5] = 0.2
    set thistype.DAMAGE[5] = 95
endmethod