static integer array MAX_LENGTH
static string array TARGET_EFFECT_ATTACH_POINT
static string array TARGET_EFFECT_PATH
static integer array DAMAGE
    
static method Init_obj_RazorBlade takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ARaz')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Razor Blade")
    call SpellObjectCreation.TEMP.SetOrder("evileye")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 90)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 12)
    call SpellObjectCreation.TEMP.SetManaCost(1, 70)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 90)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 12)
    call SpellObjectCreation.TEMP.SetManaCost(2, 85)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 90)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 12)
    call SpellObjectCreation.TEMP.SetManaCost(3, 100)
    call SpellObjectCreation.TEMP.SetRange(3, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 90)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 12)
    call SpellObjectCreation.TEMP.SetManaCost(4, 115)
    call SpellObjectCreation.TEMP.SetRange(4, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 90)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 12)
    call SpellObjectCreation.TEMP.SetManaCost(5, 130)
    call SpellObjectCreation.TEMP.SetRange(5, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWhirlwind.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FRB0', 5, 'CRB0')
    
    set thistype.MAX_LENGTH[1] = 750
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
    set thistype.DAMAGE[1] = 20
    set thistype.MAX_LENGTH[2] = 750
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
    set thistype.DAMAGE[2] = 35
    set thistype.MAX_LENGTH[3] = 750
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
    set thistype.DAMAGE[3] = 55
    set thistype.MAX_LENGTH[4] = 750
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
    set thistype.DAMAGE[4] = 80
    set thistype.MAX_LENGTH[5] = 750
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.CHEST
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
    set thistype.DAMAGE[5] = 110
endmethod