static string array CASTER_EFFECT_ATTACH_POINT
static string array EFFECT_LIGHTNING_PATH
static integer array TARGETS_AMOUNT
static integer array RESTORED_LIFE
static string array TARGET_EFFECT_ATTACH_POINT
static integer array STUN_DURATION
static string array FIRST_LIGHTNING_PATH
static string array TARGET_EFFECT_PATH
static integer array DAMAGE_AREA_WIDTH
static string array CASTER_EFFECT_PATH
static real array RESTORED_LIFE_ADD_FACTOR
static real array DELAY
static integer array DAMAGE
    
static method Init_obj_KhakiRecovery takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ARec')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Khaki Recovery")
    call SpellObjectCreation.TEMP.SetOrder("healingwave")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 6)
    call SpellObjectCreation.TEMP.SetManaCost(1, 105)
    call SpellObjectCreation.TEMP.SetRange(1, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 500)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 6)
    call SpellObjectCreation.TEMP.SetManaCost(2, 120)
    call SpellObjectCreation.TEMP.SetRange(2, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 500)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 6)
    call SpellObjectCreation.TEMP.SetManaCost(3, 135)
    call SpellObjectCreation.TEMP.SetRange(3, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 500)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 6)
    call SpellObjectCreation.TEMP.SetManaCost(4, 150)
    call SpellObjectCreation.TEMP.SetRange(4, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 500)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 6)
    call SpellObjectCreation.TEMP.SetManaCost(5, 165)
    call SpellObjectCreation.TEMP.SetRange(5, 650)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMagicImmunity.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FRc0', 5, 'CRc0')
    
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[1] = "HWSB"
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.RESTORED_LIFE[1] = 120
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.STUN_DURATION[1] = 1
    set thistype.FIRST_LIGHTNING_PATH[1] = "SPLK"
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
    set thistype.DAMAGE_AREA_WIDTH[1] = 75
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.RESTORED_LIFE_ADD_FACTOR[1] = -0.15
    set thistype.DELAY[1] = 0.35
    set thistype.DAMAGE[1] = 30
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[2] = "HWSB"
    set thistype.TARGETS_AMOUNT[2] = 3
    set thistype.RESTORED_LIFE[2] = 180
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.STUN_DURATION[2] = 1.25
    set thistype.FIRST_LIGHTNING_PATH[2] = "SPLK"
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
    set thistype.DAMAGE_AREA_WIDTH[2] = 75
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.RESTORED_LIFE_ADD_FACTOR[2] = -0.15
    set thistype.DELAY[2] = 0.35
    set thistype.DAMAGE[2] = 45
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[3] = "HWSB"
    set thistype.TARGETS_AMOUNT[3] = 4
    set thistype.RESTORED_LIFE[3] = 240
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.STUN_DURATION[3] = 1.5
    set thistype.FIRST_LIGHTNING_PATH[3] = "SPLK"
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
    set thistype.DAMAGE_AREA_WIDTH[3] = 75
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.RESTORED_LIFE_ADD_FACTOR[3] = -0.15
    set thistype.DELAY[3] = 0.35
    set thistype.DAMAGE[3] = 60
    set thistype.CASTER_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[4] = "HWSB"
    set thistype.TARGETS_AMOUNT[4] = 4
    set thistype.RESTORED_LIFE[4] = 300
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.STUN_DURATION[4] = 1.75
    set thistype.FIRST_LIGHTNING_PATH[4] = "SPLK"
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
    set thistype.DAMAGE_AREA_WIDTH[4] = 75
    set thistype.CASTER_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.RESTORED_LIFE_ADD_FACTOR[4] = -0.15
    set thistype.DELAY[4] = 0.35
    set thistype.DAMAGE[4] = 75
    set thistype.CASTER_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.EFFECT_LIGHTNING_PATH[5] = "HWSB"
    set thistype.TARGETS_AMOUNT[5] = 5
    set thistype.RESTORED_LIFE[5] = 360
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.STUN_DURATION[5] = 2
    set thistype.FIRST_LIGHTNING_PATH[5] = "SPLK"
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
    set thistype.DAMAGE_AREA_WIDTH[5] = 75
    set thistype.CASTER_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
    set thistype.RESTORED_LIFE_ADD_FACTOR[5] = -0.15
    set thistype.DELAY[5] = 0.35
    set thistype.DAMAGE[5] = 90
endmethod