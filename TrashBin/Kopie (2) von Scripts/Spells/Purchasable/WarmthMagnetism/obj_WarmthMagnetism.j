static integer array DAMAGE_PER_INTERVAL
static real array DAMAGE_INTERVAL
static string array TARGET_EFFECT_PATH
static string array EFFECT_LIGHTNING_PATH
static integer array SPEED
static string array TARGET_EFFECT_ATTACH_POINT
static integer array HIT_RANGE
    
static method Init_obj_WarmthMagnetism takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AWaM')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Warmth Magnetism")
    call SpellObjectCreation.TEMP.SetOrder("darkportal")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 6)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 6)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 6)
    call SpellObjectCreation.TEMP.SetManaCost(3, 60)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 6)
    call SpellObjectCreation.TEMP.SetManaCost(4, 60)
    call SpellObjectCreation.TEMP.SetRange(4, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 6)
    call SpellObjectCreation.TEMP.SetManaCost(5, 70)
    call SpellObjectCreation.TEMP.SetRange(5, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGnollCommandAura.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FWM0', 5, 'CWM0')
    
    set thistype.DAMAGE_PER_INTERVAL[1] = 20
    set thistype.DAMAGE_INTERVAL[1] = 0.5
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[1] = "MBUR"
    set thistype.SPEED[1] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[1] = 120
    set thistype.DAMAGE_PER_INTERVAL[2] = 30
    set thistype.DAMAGE_INTERVAL[2] = 0.5
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[2] = "MBUR"
    set thistype.SPEED[2] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[2] = 120
    set thistype.DAMAGE_PER_INTERVAL[3] = 40
    set thistype.DAMAGE_INTERVAL[3] = 0.5
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[3] = "MBUR"
    set thistype.SPEED[3] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[3] = 120
    set thistype.DAMAGE_PER_INTERVAL[4] = 50
    set thistype.DAMAGE_INTERVAL[4] = 0.5
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[4] = "MBUR"
    set thistype.SPEED[4] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[4] = 120
    set thistype.DAMAGE_PER_INTERVAL[5] = 60
    set thistype.DAMAGE_INTERVAL[5] = 0.5
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    set thistype.EFFECT_LIGHTNING_PATH[5] = "MBUR"
    set thistype.SPEED[5] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.HIT_RANGE[5] = 120
endmethod