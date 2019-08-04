static string array DAMAGE_EFFECT_ATTACH_POINT
static string array DAMAGE_EFFECT_PATH
static integer array DURATION
static real array INTERVAL
static real array ABSORPTION_FACTOR
static real array DAMAGE_PER_INTERVAL
static real array MAX_HEAL_PER_INTERVAL
    
static method Init_obj_WanShroud takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AWSh')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Wan Shroud")
    call SpellObjectCreation.TEMP.SetOrder("banish")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 240)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 17)
    call SpellObjectCreation.TEMP.SetManaCost(1, 120)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 260)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 17)
    call SpellObjectCreation.TEMP.SetManaCost(2, 135)
    call SpellObjectCreation.TEMP.SetRange(2, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 280)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 17)
    call SpellObjectCreation.TEMP.SetManaCost(3, 150)
    call SpellObjectCreation.TEMP.SetRange(3, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 300)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 17)
    call SpellObjectCreation.TEMP.SetManaCost(4, 165)
    call SpellObjectCreation.TEMP.SetRange(4, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 320)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 17)
    call SpellObjectCreation.TEMP.SetManaCost(5, 180)
    call SpellObjectCreation.TEMP.SetRange(5, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCyclone.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FWS0', 5, 'CWS0')
    
    set thistype.DAMAGE_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.DAMAGE_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.DURATION[1] = 10
    set thistype.INTERVAL[1] = 0.75
    set thistype.ABSORPTION_FACTOR[1] = 0.5
    set thistype.DAMAGE_PER_INTERVAL[1] = 1.5
    set thistype.MAX_HEAL_PER_INTERVAL[1] = 7.5
    set thistype.DAMAGE_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.DAMAGE_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.DURATION[2] = 10
    set thistype.INTERVAL[2] = 0.75
    set thistype.ABSORPTION_FACTOR[2] = 0.5
    set thistype.DAMAGE_PER_INTERVAL[2] = 2.5
    set thistype.MAX_HEAL_PER_INTERVAL[2] = 10
    set thistype.DAMAGE_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.DAMAGE_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.DURATION[3] = 10
    set thistype.INTERVAL[3] = 0.75
    set thistype.ABSORPTION_FACTOR[3] = 0.5
    set thistype.DAMAGE_PER_INTERVAL[3] = 4
    set thistype.MAX_HEAL_PER_INTERVAL[3] = 12.5
    set thistype.DAMAGE_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.DAMAGE_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.DURATION[4] = 10
    set thistype.INTERVAL[4] = 0.75
    set thistype.ABSORPTION_FACTOR[4] = 0.5
    set thistype.DAMAGE_PER_INTERVAL[4] = 6
    set thistype.MAX_HEAL_PER_INTERVAL[4] = 15
    set thistype.DAMAGE_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.DAMAGE_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
    set thistype.DURATION[5] = 10
    set thistype.INTERVAL[5] = 0.75
    set thistype.ABSORPTION_FACTOR[5] = 0.5
    set thistype.DAMAGE_PER_INTERVAL[5] = 8.5
    set thistype.MAX_HEAL_PER_INTERVAL[5] = 17.5
endmethod