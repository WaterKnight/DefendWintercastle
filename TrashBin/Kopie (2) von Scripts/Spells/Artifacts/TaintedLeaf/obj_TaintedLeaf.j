static integer array HEAL
static string array HEAL_TARGET_EFFECT_ATTACH_POINT
static real array SELF_FACTOR
static integer array SLEEP_DURATION
static integer array SLEEP_HERO_DURATION
static string array HEAL_TARGET_EFFECT_PATH
static real array HEAL_FACTOR
    
static method Init_obj_TaintedLeaf takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATaL')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Tainted Leaf")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 6)
    call SpellObjectCreation.TEMP.SetManaCost(1, 70)
    call SpellObjectCreation.TEMP.SetRange(1, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 6)
    call SpellObjectCreation.TEMP.SetManaCost(2, 70)
    call SpellObjectCreation.TEMP.SetRange(2, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 6)
    call SpellObjectCreation.TEMP.SetManaCost(3, 70)
    call SpellObjectCreation.TEMP.SetRange(3, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 6)
    call SpellObjectCreation.TEMP.SetManaCost(4, 70)
    call SpellObjectCreation.TEMP.SetRange(4, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 6)
    call SpellObjectCreation.TEMP.SetManaCost(5, 70)
    call SpellObjectCreation.TEMP.SetRange(5, 800)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp")
    
    set thistype.HEAL[1] = 80
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.SELF_FACTOR[1] = 0.7
    set thistype.SLEEP_DURATION[1] = 3
    set thistype.SLEEP_HERO_DURATION[1] = 1
    set thistype.HEAL_TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_FACTOR[1] = 0.05
    set thistype.HEAL[2] = 100
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.SELF_FACTOR[2] = 0.7
    set thistype.SLEEP_DURATION[2] = 3
    set thistype.SLEEP_HERO_DURATION[2] = 1
    set thistype.HEAL_TARGET_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_FACTOR[2] = 0.1
    set thistype.HEAL[3] = 120
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.SELF_FACTOR[3] = 0.7
    set thistype.SLEEP_DURATION[3] = 3
    set thistype.SLEEP_HERO_DURATION[3] = 1
    set thistype.HEAL_TARGET_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_FACTOR[3] = 0.15
    set thistype.HEAL[4] = 140
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.SELF_FACTOR[4] = 0.7
    set thistype.SLEEP_DURATION[4] = 3
    set thistype.SLEEP_HERO_DURATION[4] = 1
    set thistype.HEAL_TARGET_EFFECT_PATH[4] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_FACTOR[4] = 0.2
    set thistype.HEAL[5] = 160
    set thistype.HEAL_TARGET_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.SELF_FACTOR[5] = 0.7
    set thistype.SLEEP_DURATION[5] = 3
    set thistype.SLEEP_HERO_DURATION[5] = 1
    set thistype.HEAL_TARGET_EFFECT_PATH[5] = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
    set thistype.HEAL_FACTOR[5] = 0.25
endmethod