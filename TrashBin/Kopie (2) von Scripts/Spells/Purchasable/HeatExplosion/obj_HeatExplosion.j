static integer array ACCELERATION
static string array CASTER_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_ATTACH_POINT
static real array BUFF_DURATION
static integer array DURATION
static string array CASTER_EFFECT2_ATTACH_POINT
static string array CASTER_BUFF_EFFECT_PATH
static string array CASTER_EFFECT_PATH
static string array CASTER_BUFF_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static real array INTERVAL
static string array CASTER_EFFECT2_PATH
static integer array SPEED
static real array DELAY
static integer array DAMAGE
    
static method Init_obj_HeatExplosion takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHeE')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Heat Explosion")
    call SpellObjectCreation.TEMP.SetOrder("inferno")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 200)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 9)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 200)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 9)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 9)
    call SpellObjectCreation.TEMP.SetManaCost(3, 60)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 200)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 9)
    call SpellObjectCreation.TEMP.SetManaCost(4, 70)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 200)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 9)
    call SpellObjectCreation.TEMP.SetManaCost(5, 80)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNImmolationOn.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FHE0', 5, 'CHE0')
    
    set thistype.ACCELERATION[1] = -1200
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.BUFF_DURATION[1] = 0.5
    set thistype.DURATION[1] = 3
    set thistype.CASTER_EFFECT2_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.CASTER_BUFF_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    set thistype.CASTER_BUFF_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    set thistype.INTERVAL[1] = 0.125
    set thistype.CASTER_EFFECT2_PATH[1] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.SPEED[1] = 600
    set thistype.DELAY[1] = 0.5
    set thistype.DAMAGE[1] = 5
    set thistype.ACCELERATION[2] = -1200
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.BUFF_DURATION[2] = 0.5
    set thistype.DURATION[2] = 3
    set thistype.CASTER_EFFECT2_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.CASTER_BUFF_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    set thistype.CASTER_BUFF_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    set thistype.INTERVAL[2] = 0.125
    set thistype.CASTER_EFFECT2_PATH[2] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.SPEED[2] = 600
    set thistype.DELAY[2] = 0.5
    set thistype.DAMAGE[2] = 8
    set thistype.ACCELERATION[3] = -1200
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.BUFF_DURATION[3] = 0.5
    set thistype.DURATION[3] = 3
    set thistype.CASTER_EFFECT2_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.CASTER_BUFF_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    set thistype.CASTER_BUFF_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    set thistype.INTERVAL[3] = 0.125
    set thistype.CASTER_EFFECT2_PATH[3] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.SPEED[3] = 600
    set thistype.DELAY[3] = 0.5
    set thistype.DAMAGE[3] = 13
    set thistype.ACCELERATION[4] = -1200
    set thistype.CASTER_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.BUFF_DURATION[4] = 0.5
    set thistype.DURATION[4] = 3
    set thistype.CASTER_EFFECT2_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.CASTER_BUFF_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
    set thistype.CASTER_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    set thistype.CASTER_BUFF_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    set thistype.INTERVAL[4] = 0.125
    set thistype.CASTER_EFFECT2_PATH[4] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.SPEED[4] = 600
    set thistype.DELAY[4] = 0.5
    set thistype.DAMAGE[4] = 20
    set thistype.ACCELERATION[5] = -1200
    set thistype.CASTER_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.BUFF_DURATION[5] = 0.5
    set thistype.DURATION[5] = 3
    set thistype.CASTER_EFFECT2_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.CASTER_BUFF_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
    set thistype.CASTER_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
    set thistype.CASTER_BUFF_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
    set thistype.INTERVAL[5] = 0.125
    set thistype.CASTER_EFFECT2_PATH[5] = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    set thistype.SPEED[5] = 600
    set thistype.DELAY[5] = 0.5
    set thistype.DAMAGE[5] = 28
endmethod