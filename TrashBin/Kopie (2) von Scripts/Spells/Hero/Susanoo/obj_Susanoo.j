static real array SPELL_POWER_INCREMENT
static integer array DURATION
static real array ATTACK_RATE_INCREMENT
static string array SPECIAL_EFFECT_PATH
static integer array DURATION_ADD
static string array ADD_TIME_EFFECT_PATH
static string array ADD_TIME_EFFECT_ATTACH_POINT
static real array ARMOR_INCREMENT
static real array DURATION_ADD_FACTOR
    
static method Init_obj_Susanoo takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASus')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call SpellObjectCreation.TEMP.SetLevelsAmount(2)
    call SpellObjectCreation.TEMP.SetName("Susanoo")
    call SpellObjectCreation.TEMP.SetOrder("manashieldon")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 110)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 60)
    call SpellObjectCreation.TEMP.SetManaCost(2, 170)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHowlOfTerror.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSu0', 2, 'CSu0')
    
    set thistype.SPELL_POWER_INCREMENT[1] = 0.5
    set thistype.DURATION[1] = 12
    set thistype.ATTACK_RATE_INCREMENT[1] = 0.35
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl"
    set thistype.DURATION_ADD[1] = 2
    set thistype.ADD_TIME_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
    set thistype.ADD_TIME_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.ARMOR_INCREMENT[1] = 0.35
    set thistype.DURATION_ADD_FACTOR[1] = -0.3
    set thistype.SPELL_POWER_INCREMENT[2] = 1
    set thistype.DURATION[2] = 12
    set thistype.ATTACK_RATE_INCREMENT[2] = 0.6
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl"
    set thistype.DURATION_ADD[2] = 2
    set thistype.ADD_TIME_EFFECT_PATH[2] = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
    set thistype.ADD_TIME_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.ARMOR_INCREMENT[2] = 0.45
    set thistype.DURATION_ADD_FACTOR[2] = -0.3
endmethod