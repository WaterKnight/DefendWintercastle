static string array TARGET_EFFECT_ATTACH_POINT
static integer array HIT_RANGE
static integer array HEAL
static string array TARGET_EFFECT_PATH
static integer array SILENCE_DURATION
static integer array SPEED
static integer array HEAL_SPELL_POWER_MOD_FACTOR
static integer array EFFECT_CASTER_AMOUNT
static integer array DAMAGE
    
static method Init_obj_EmphaticBite takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AEmB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Emphatic Bite")
    call SpellObjectCreation.TEMP.SetOrder("cannibalize")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 11)
    call SpellObjectCreation.TEMP.SetManaCost(1, 75)
    call SpellObjectCreation.TEMP.SetRange(1, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 85)
    call SpellObjectCreation.TEMP.SetRange(2, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 9)
    call SpellObjectCreation.TEMP.SetManaCost(3, 100)
    call SpellObjectCreation.TEMP.SetRange(3, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 8)
    call SpellObjectCreation.TEMP.SetManaCost(4, 115)
    call SpellObjectCreation.TEMP.SetRange(4, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 7)
    call SpellObjectCreation.TEMP.SetManaCost(5, 130)
    call SpellObjectCreation.TEMP.SetRange(5, 550)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCannibalize.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FEB0', 5, 'CEB0')
    
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[1] = 120
    set thistype.HEAL[1] = 45
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.SILENCE_DURATION[1] = 3
    set thistype.SPEED[1] = 1000
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[1] = 1
    set thistype.EFFECT_CASTER_AMOUNT[1] = 2
    set thistype.DAMAGE[1] = 45
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[2] = 120
    set thistype.HEAL[2] = 65
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.SILENCE_DURATION[2] = 3
    set thistype.SPEED[2] = 1000
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[2] = 1
    set thistype.EFFECT_CASTER_AMOUNT[2] = 2
    set thistype.DAMAGE[2] = 65
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[3] = 120
    set thistype.HEAL[3] = 90
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.SILENCE_DURATION[3] = 3
    set thistype.SPEED[3] = 1000
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[3] = 1
    set thistype.EFFECT_CASTER_AMOUNT[3] = 2
    set thistype.DAMAGE[3] = 90
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[4] = 120
    set thistype.HEAL[4] = 120
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.SILENCE_DURATION[4] = 3
    set thistype.SPEED[4] = 1000
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[4] = 1
    set thistype.EFFECT_CASTER_AMOUNT[4] = 2
    set thistype.DAMAGE[4] = 120
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[5] = 120
    set thistype.HEAL[5] = 155
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.SILENCE_DURATION[5] = 3
    set thistype.SPEED[5] = 1000
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[5] = 1
    set thistype.EFFECT_CASTER_AMOUNT[5] = 2
    set thistype.DAMAGE[5] = 155
endmethod