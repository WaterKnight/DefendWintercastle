static string array START_EFFECT_PATH
static string array DAMAGE_TARGET_EFFECT_ATTACH_POINT
static integer array BUFF_DURATION
static integer array MAX_RANGE
static integer array LIFE_LEECH_INCREMENT
static integer array HEAL
static string array TARGET_EFFECT_PATH
static integer array DAMAGE
static string array DAMAGE_TARGET_EFFECT_PATH
static integer array HEAL_PER_TARGET
static string array HEAL_TARGET_EFFECT_PATH
static string array HEAL_TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_SapphireblueDagger takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASaD')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Sapphireblue Dagger")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 200)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 11)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 200)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 11)
    call SpellObjectCreation.TEMP.SetManaCost(2, 30)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 11)
    call SpellObjectCreation.TEMP.SetManaCost(3, 30)
    call SpellObjectCreation.TEMP.SetRange(3, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 200)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 11)
    call SpellObjectCreation.TEMP.SetManaCost(4, 30)
    call SpellObjectCreation.TEMP.SetRange(4, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 200)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 11)
    call SpellObjectCreation.TEMP.SetManaCost(5, 30)
    call SpellObjectCreation.TEMP.SetRange(5, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDaggerOfEscape.blp")
    
    set thistype.START_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.HEAD
    set thistype.BUFF_DURATION[1] = 7
    set thistype.MAX_RANGE[1] = 500
    set thistype.LIFE_LEECH_INCREMENT[1] = 3
    set thistype.HEAL[1] = 25
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    set thistype.DAMAGE[1] = 0
    set thistype.DAMAGE_TARGET_EFFECT_PATH[1] = "none"
    set thistype.HEAL_PER_TARGET[1] = 5
    set thistype.HEAL_TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.START_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.HEAD
    set thistype.BUFF_DURATION[2] = 7
    set thistype.MAX_RANGE[2] = 500
    set thistype.LIFE_LEECH_INCREMENT[2] = 5
    set thistype.HEAL[2] = 36
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    set thistype.DAMAGE[2] = 0
    set thistype.DAMAGE_TARGET_EFFECT_PATH[2] = "none"
    set thistype.HEAL_PER_TARGET[2] = 6
    set thistype.HEAL_TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.START_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.HEAD
    set thistype.BUFF_DURATION[3] = 7
    set thistype.MAX_RANGE[3] = 500
    set thistype.LIFE_LEECH_INCREMENT[3] = 7
    set thistype.HEAL[3] = 45
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    set thistype.DAMAGE[3] = 0
    set thistype.DAMAGE_TARGET_EFFECT_PATH[3] = "none"
    set thistype.HEAL_PER_TARGET[3] = 7
    set thistype.HEAL_TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.START_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.HEAD
    set thistype.BUFF_DURATION[4] = 7
    set thistype.MAX_RANGE[4] = 500
    set thistype.LIFE_LEECH_INCREMENT[4] = 9
    set thistype.HEAL[4] = 52
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    set thistype.DAMAGE[4] = 0
    set thistype.DAMAGE_TARGET_EFFECT_PATH[4] = "none"
    set thistype.HEAL_PER_TARGET[4] = 8
    set thistype.HEAL_TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.START_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.HEAD
    set thistype.BUFF_DURATION[5] = 7
    set thistype.MAX_RANGE[5] = 500
    set thistype.LIFE_LEECH_INCREMENT[5] = 12
    set thistype.HEAL[5] = 57
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    set thistype.DAMAGE[5] = 0
    set thistype.DAMAGE_TARGET_EFFECT_PATH[5] = "none"
    set thistype.HEAL_PER_TARGET[5] = 9
    set thistype.HEAL_TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
endmethod