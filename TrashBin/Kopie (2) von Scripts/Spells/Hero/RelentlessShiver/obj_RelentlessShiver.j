static string array SPECIAL_EFFECT_ATTACH_POINT
static integer array MAX_TARGETS_AMOUNT
static real array INTERVAL
static integer array MANA_COST_PER_SECOND
static string array SPECIAL_EFFECT_PATH
static integer array MANA_COST_BUFFER
    
static method Init_obj_RelentlessShiver takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AReS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Relentless Shiver")
    call SpellObjectCreation.TEMP.SetOrder("animatedead")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 80)
    call SpellObjectCreation.TEMP.SetManaCost(1, 10)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 500)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 80)
    call SpellObjectCreation.TEMP.SetManaCost(2, 10)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 500)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 80)
    call SpellObjectCreation.TEMP.SetManaCost(3, 10)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FRS0', 3, 'CRS0')
    
    set thistype.SPECIAL_EFFECT_ATTACH_POINT[1] = AttachPoint.OVERHEAD
    set thistype.MAX_TARGETS_AMOUNT[1] = 5
    set thistype.INTERVAL[1] = 0.75
    set thistype.MANA_COST_PER_SECOND[1] = 8
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
    set thistype.MANA_COST_BUFFER[1] = 10
    set thistype.SPECIAL_EFFECT_ATTACH_POINT[2] = AttachPoint.OVERHEAD
    set thistype.MAX_TARGETS_AMOUNT[2] = 8
    set thistype.INTERVAL[2] = 0.75
    set thistype.MANA_COST_PER_SECOND[2] = 13
    set thistype.SPECIAL_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
    set thistype.MANA_COST_BUFFER[2] = 10
    set thistype.SPECIAL_EFFECT_ATTACH_POINT[3] = AttachPoint.OVERHEAD
    set thistype.MAX_TARGETS_AMOUNT[3] = 11
    set thistype.INTERVAL[3] = 0.75
    set thistype.MANA_COST_PER_SECOND[3] = 18
    set thistype.SPECIAL_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
    set thistype.MANA_COST_BUFFER[3] = 10
endmethod