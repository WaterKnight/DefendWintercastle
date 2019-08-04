static integer array DISPELLED_TARGETS_AMOUNT
static integer array BURNED_MANA_MAX
static string array TARGET_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static integer array MAX_LENGTH
static integer array SPEED
static string array EFFECT_LIGHTNING_PATH
static integer array HEIGHT
static integer array START_OFFSET
    
static method Init_obj_ManaLaser takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMaL')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Mana Laser")
    call SpellObjectCreation.TEMP.SetOrder("manaburn")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 200)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 90)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 200)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 15)
    call SpellObjectCreation.TEMP.SetManaCost(2, 105)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 200)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 15)
    call SpellObjectCreation.TEMP.SetManaCost(3, 120)
    call SpellObjectCreation.TEMP.SetRange(3, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 200)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 15)
    call SpellObjectCreation.TEMP.SetManaCost(4, 135)
    call SpellObjectCreation.TEMP.SetRange(4, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 200)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 15)
    call SpellObjectCreation.TEMP.SetManaCost(5, 150)
    call SpellObjectCreation.TEMP.SetRange(5, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNManaBurn.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FML0', 5, 'CML0')
    
    set thistype.DISPELLED_TARGETS_AMOUNT[1] = 3
    set thistype.BURNED_MANA_MAX[1] = 50
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
    set thistype.MAX_LENGTH[1] = 650
    set thistype.SPEED[1] = 900
    set thistype.EFFECT_LIGHTNING_PATH[1] = "MBUR"
    set thistype.HEIGHT[1] = 50
    set thistype.START_OFFSET[1] = 90
    set thistype.DISPELLED_TARGETS_AMOUNT[2] = 3
    set thistype.BURNED_MANA_MAX[2] = 80
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
    set thistype.MAX_LENGTH[2] = 650
    set thistype.SPEED[2] = 900
    set thistype.EFFECT_LIGHTNING_PATH[2] = "MBUR"
    set thistype.HEIGHT[2] = 50
    set thistype.START_OFFSET[2] = 90
    set thistype.DISPELLED_TARGETS_AMOUNT[3] = 4
    set thistype.BURNED_MANA_MAX[3] = 110
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
    set thistype.MAX_LENGTH[3] = 650
    set thistype.SPEED[3] = 900
    set thistype.EFFECT_LIGHTNING_PATH[3] = "MBUR"
    set thistype.HEIGHT[3] = 50
    set thistype.START_OFFSET[3] = 90
    set thistype.DISPELLED_TARGETS_AMOUNT[4] = 4
    set thistype.BURNED_MANA_MAX[4] = 140
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
    set thistype.MAX_LENGTH[4] = 650
    set thistype.SPEED[4] = 900
    set thistype.EFFECT_LIGHTNING_PATH[4] = "MBUR"
    set thistype.HEIGHT[4] = 50
    set thistype.START_OFFSET[4] = 90
    set thistype.DISPELLED_TARGETS_AMOUNT[5] = 5
    set thistype.BURNED_MANA_MAX[5] = 180
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
    set thistype.MAX_LENGTH[5] = 650
    set thistype.SPEED[5] = 900
    set thistype.EFFECT_LIGHTNING_PATH[5] = "MBUR"
    set thistype.HEIGHT[5] = 50
    set thistype.START_OFFSET[5] = 90
endmethod