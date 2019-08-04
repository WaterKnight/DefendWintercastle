static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
static integer array DURATION
static integer array TARGETS_AMOUNT
static integer array HERO_DURATION
    
static method Init_obj_SleepingDraft takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASlD')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Sleeping Draft")
    call SpellObjectCreation.TEMP.SetOrder("sleep")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 350)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 16)
    call SpellObjectCreation.TEMP.SetManaCost(1, 120)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 350)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 15)
    call SpellObjectCreation.TEMP.SetManaCost(2, 120)
    call SpellObjectCreation.TEMP.SetRange(2, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 350)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 14)
    call SpellObjectCreation.TEMP.SetManaCost(3, 120)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 350)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 13)
    call SpellObjectCreation.TEMP.SetManaCost(4, 120)
    call SpellObjectCreation.TEMP.SetRange(4, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 350)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 12)
    call SpellObjectCreation.TEMP.SetManaCost(5, 120)
    call SpellObjectCreation.TEMP.SetRange(5, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfClarity.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSD0', 5, 'CSD0')
    
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.DURATION[1] = 5
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.HERO_DURATION[1] = 1
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.DURATION[2] = 6
    set thistype.TARGETS_AMOUNT[2] = 4
    set thistype.HERO_DURATION[2] = 1.5
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.DURATION[3] = 7
    set thistype.TARGETS_AMOUNT[3] = 5
    set thistype.HERO_DURATION[3] = 2
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.DURATION[4] = 8
    set thistype.TARGETS_AMOUNT[4] = 6
    set thistype.HERO_DURATION[4] = 2.5
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.DURATION[5] = 9
    set thistype.TARGETS_AMOUNT[5] = 7
    set thistype.HERO_DURATION[5] = 3
endmethod