static integer array MAX_LENGTH
static real array INTERVAL
static integer array MOVING_AREA_RANGE
static string array MAX_ANGLE_D
static integer array SPEED
static real array CASTER_SIGHT_D_FACTOR
static integer array ANGLE_D_FACTOR
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_FrozenStar takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFrS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Frozen Star")
    call SpellObjectCreation.TEMP.SetOrder("carrionswarm")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 400)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 9)
    call SpellObjectCreation.TEMP.SetManaCost(1, 55)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 400)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 9)
    call SpellObjectCreation.TEMP.SetManaCost(2, 75)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 400)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 9)
    call SpellObjectCreation.TEMP.SetManaCost(3, 95)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 400)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 9)
    call SpellObjectCreation.TEMP.SetManaCost(4, 115)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 400)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 9)
    call SpellObjectCreation.TEMP.SetManaCost(5, 135)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FFS0', 5, 'CFS0')
    
    set thistype.MAX_LENGTH[1] = 700
    set thistype.INTERVAL[1] = 0.035
    set thistype.MOVING_AREA_RANGE[1] = 200
    set thistype.MAX_ANGLE_D[1] = "0.25 * Math.QUARTER_ANGLE"
    set thistype.SPEED[1] = 600
    set thistype.CASTER_SIGHT_D_FACTOR[1] = 0.1
    set thistype.ANGLE_D_FACTOR[1] = 10
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    set thistype.MAX_LENGTH[2] = 700
    set thistype.INTERVAL[2] = 0.035
    set thistype.MOVING_AREA_RANGE[2] = 200
    set thistype.MAX_ANGLE_D[2] = "0.25 * Math.QUARTER_ANGLE"
    set thistype.SPEED[2] = 600
    set thistype.CASTER_SIGHT_D_FACTOR[2] = 0.1
    set thistype.ANGLE_D_FACTOR[2] = 10
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    set thistype.MAX_LENGTH[3] = 700
    set thistype.INTERVAL[3] = 0.035
    set thistype.MOVING_AREA_RANGE[3] = 200
    set thistype.MAX_ANGLE_D[3] = "0.25 * Math.QUARTER_ANGLE"
    set thistype.SPEED[3] = 600
    set thistype.CASTER_SIGHT_D_FACTOR[3] = 0.1
    set thistype.ANGLE_D_FACTOR[3] = 10
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    set thistype.MAX_LENGTH[4] = 700
    set thistype.INTERVAL[4] = 0.035
    set thistype.MOVING_AREA_RANGE[4] = 200
    set thistype.MAX_ANGLE_D[4] = "0.25 * Math.QUARTER_ANGLE"
    set thistype.SPEED[4] = 600
    set thistype.CASTER_SIGHT_D_FACTOR[4] = 0.1
    set thistype.ANGLE_D_FACTOR[4] = 10
    set thistype.SPECIAL_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    set thistype.MAX_LENGTH[5] = 700
    set thistype.INTERVAL[5] = 0.035
    set thistype.MOVING_AREA_RANGE[5] = 200
    set thistype.MAX_ANGLE_D[5] = "0.25 * Math.QUARTER_ANGLE"
    set thistype.SPEED[5] = 600
    set thistype.CASTER_SIGHT_D_FACTOR[5] = 0.1
    set thistype.ANGLE_D_FACTOR[5] = 10
    set thistype.SPECIAL_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
endmethod