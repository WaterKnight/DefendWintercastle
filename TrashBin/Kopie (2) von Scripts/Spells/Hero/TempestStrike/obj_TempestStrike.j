static integer array SPEED_END
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
static integer array LENGTH
static real array DURATION
static integer array DAMAGE
    
static method Init_obj_TempestStrike takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATeS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_FIRST)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Tempest Strike")
    call SpellObjectCreation.TEMP.SetOrder("evileye")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 90)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 70)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 90)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 85)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 90)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 10)
    call SpellObjectCreation.TEMP.SetManaCost(3, 100)
    call SpellObjectCreation.TEMP.SetRange(3, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 90)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 10)
    call SpellObjectCreation.TEMP.SetManaCost(4, 115)
    call SpellObjectCreation.TEMP.SetRange(4, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 90)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 10)
    call SpellObjectCreation.TEMP.SetManaCost(5, 130)
    call SpellObjectCreation.TEMP.SetRange(5, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCleavingAttack.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FTe0', 5, 'CTe0')
    
    set thistype.SPEED_END[1] = 200
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
    set thistype.LENGTH[1] = 600
    set thistype.DURATION[1] = 0.75
    set thistype.DAMAGE[1] = 30
    set thistype.SPEED_END[2] = 200
    set thistype.TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.CHEST
    set thistype.LENGTH[2] = 600
    set thistype.DURATION[2] = 0.75
    set thistype.DAMAGE[2] = 60
    set thistype.SPEED_END[3] = 200
    set thistype.TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.CHEST
    set thistype.LENGTH[3] = 600
    set thistype.DURATION[3] = 0.75
    set thistype.DAMAGE[3] = 90
    set thistype.SPEED_END[4] = 200
    set thistype.TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.CHEST
    set thistype.LENGTH[4] = 600
    set thistype.DURATION[4] = 0.75
    set thistype.DAMAGE[4] = 120
    set thistype.SPEED_END[5] = 200
    set thistype.TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.CHEST
    set thistype.LENGTH[5] = 600
    set thistype.DURATION[5] = 0.75
    set thistype.DAMAGE[5] = 150
endmethod