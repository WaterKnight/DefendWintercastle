static string array VICTIM_EFFECT_PATH
static string array SUMMON_EFFECT_PATH
static integer array DAMAGE_FACTOR
static integer array DURATION
static string array DEATH_EFFECT_PATH
static string array SUMMON_EFFECT_ATTACH_POINT
static integer array SUMMONS_AMOUNT
static string array VICTIM_EFFECT_ATTACH_POINT
static integer array STOLEN_MANA
static integer array SUMMON_OFFSET
static string array SUMMON_UNIT_TYPES
static string array DEATH_EFFECT_ATTACH_POINT
    
static method Init_obj_GhostSword takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AGhS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Ghost Sword")
    call SpellObjectCreation.TEMP.SetOrder("summonwareagle")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 12)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 12)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 12)
    call SpellObjectCreation.TEMP.SetManaCost(3, 60)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 12)
    call SpellObjectCreation.TEMP.SetManaCost(4, 70)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 12)
    call SpellObjectCreation.TEMP.SetManaCost(5, 80)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FGS0', 5, 'CGS0')
    
    set thistype.VICTIM_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.SUMMON_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_FACTOR[1] = 1
    set thistype.DURATION[1] = 25
    set thistype.DEATH_EFFECT_PATH[1] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[1] = AttachPoint.WEAPON
    set thistype.SUMMONS_AMOUNT[1] = 2
    set thistype.VICTIM_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.STOLEN_MANA[1] = 10
    set thistype.SUMMON_OFFSET[1] = 100
    set thistype.SUMMON_UNIT_TYPES[1] = UnitType.GHOST_SWORD
    set thistype.DEATH_EFFECT_ATTACH_POINT[1] = AttachPoint.WEAPON
    set thistype.VICTIM_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.SUMMON_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_FACTOR[2] = 1.5
    set thistype.DURATION[2] = 25
    set thistype.DEATH_EFFECT_PATH[2] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[2] = AttachPoint.WEAPON
    set thistype.SUMMONS_AMOUNT[2] = 2
    set thistype.VICTIM_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.STOLEN_MANA[2] = 15
    set thistype.SUMMON_OFFSET[2] = 100
    set thistype.SUMMON_UNIT_TYPES[2] = UnitType.GHOST_SWORD2
    set thistype.DEATH_EFFECT_ATTACH_POINT[2] = AttachPoint.WEAPON
    set thistype.VICTIM_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.SUMMON_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_FACTOR[3] = 2
    set thistype.DURATION[3] = 25
    set thistype.DEATH_EFFECT_PATH[3] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[3] = AttachPoint.WEAPON
    set thistype.SUMMONS_AMOUNT[3] = 3
    set thistype.VICTIM_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.STOLEN_MANA[3] = 20
    set thistype.SUMMON_OFFSET[3] = 100
    set thistype.SUMMON_UNIT_TYPES[3] = UnitType.GHOST_SWORD3
    set thistype.DEATH_EFFECT_ATTACH_POINT[3] = AttachPoint.WEAPON
    set thistype.VICTIM_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.SUMMON_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_FACTOR[4] = 2.5
    set thistype.DURATION[4] = 25
    set thistype.DEATH_EFFECT_PATH[4] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[4] = AttachPoint.WEAPON
    set thistype.SUMMONS_AMOUNT[4] = 3
    set thistype.VICTIM_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.STOLEN_MANA[4] = 25
    set thistype.SUMMON_OFFSET[4] = 100
    set thistype.SUMMON_UNIT_TYPES[4] = UnitType.GHOST_SWORD4
    set thistype.DEATH_EFFECT_ATTACH_POINT[4] = AttachPoint.WEAPON
    set thistype.VICTIM_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.SUMMON_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.DAMAGE_FACTOR[5] = 3
    set thistype.DURATION[5] = 25
    set thistype.DEATH_EFFECT_PATH[5] = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[5] = AttachPoint.WEAPON
    set thistype.SUMMONS_AMOUNT[5] = 4
    set thistype.VICTIM_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.STOLEN_MANA[5] = 30
    set thistype.SUMMON_OFFSET[5] = 100
    set thistype.SUMMON_UNIT_TYPES[5] = UnitType.GHOST_SWORD5
    set thistype.DEATH_EFFECT_ATTACH_POINT[5] = AttachPoint.WEAPON
endmethod