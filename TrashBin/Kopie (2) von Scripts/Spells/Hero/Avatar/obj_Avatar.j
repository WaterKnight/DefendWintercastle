static real array LIFE_LEECH_SPELL_POWER_MOD_FACTOR
static integer array DURATION
static integer array LIFE_SPELL_POWER_MOD_FACTOR
static integer array SCALE_DURATION
static integer array LIFE_INCREMENT
static integer array DAMAGE_INCREMENT
static integer array ARMOR_INCREMENT
static integer array LIFE_LEECH_INCREMENT
static string array SPECIAL_EFFECT_PATH
static real array SCALE_INCREMENT
    
static method Init_obj_Avatar takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AAva')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Avatar")
    call SpellObjectCreation.TEMP.SetOrder("avatar")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 70)
    call SpellObjectCreation.TEMP.SetManaCost(1, 125)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 70)
    call SpellObjectCreation.TEMP.SetManaCost(2, 125)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 70)
    call SpellObjectCreation.TEMP.SetManaCost(3, 125)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvatar.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FAv0', 3, 'CAv0')
    
    set thistype.LIFE_LEECH_SPELL_POWER_MOD_FACTOR[1] = 0.125
    set thistype.DURATION[1] = 30
    set thistype.LIFE_SPELL_POWER_MOD_FACTOR[1] = 3
    set thistype.SCALE_DURATION[1] = 1
    set thistype.LIFE_INCREMENT[1] = 500
    set thistype.DAMAGE_INCREMENT[1] = 20
    set thistype.ARMOR_INCREMENT[1] = 5
    set thistype.LIFE_LEECH_INCREMENT[1] = 5
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.SCALE_INCREMENT[1] = 0.3
    set thistype.LIFE_LEECH_SPELL_POWER_MOD_FACTOR[2] = 0.125
    set thistype.DURATION[2] = 45
    set thistype.LIFE_SPELL_POWER_MOD_FACTOR[2] = 3
    set thistype.SCALE_DURATION[2] = 1
    set thistype.LIFE_INCREMENT[2] = 750
    set thistype.DAMAGE_INCREMENT[2] = 30
    set thistype.ARMOR_INCREMENT[2] = 7.5
    set thistype.LIFE_LEECH_INCREMENT[2] = 10
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.SCALE_INCREMENT[2] = 0.5
    set thistype.LIFE_LEECH_SPELL_POWER_MOD_FACTOR[3] = 0.125
    set thistype.DURATION[3] = 60
    set thistype.LIFE_SPELL_POWER_MOD_FACTOR[3] = 3
    set thistype.SCALE_DURATION[3] = 1
    set thistype.LIFE_INCREMENT[3] = 1000
    set thistype.DAMAGE_INCREMENT[3] = 40
    set thistype.ARMOR_INCREMENT[3] = 10
    set thistype.LIFE_LEECH_INCREMENT[3] = 15
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
    set thistype.SCALE_INCREMENT[3] = 0.7
endmethod