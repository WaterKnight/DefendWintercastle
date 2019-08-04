static integer array SPEED_ADD
static real array DAMAGE_SPEED_FACTOR_PER_SECOND
static string array SPECIAL_EFFECT_PATH
static string array TARGET_EFFECT_PATH
static real array SPECIAL_EFFECT_SCALE
static real array INTERVAL
static integer array SPEED
static integer array MAX_LENGTH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_Stampede takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AStm')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Stampede")
    call SpellObjectCreation.TEMP.SetOrder("stampede")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 8)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 1000)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSmash.blp")
    
    set thistype.SPEED_ADD[1] = 300
    set thistype.DAMAGE_SPEED_FACTOR_PER_SECOND[1] = 0.2
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl"
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Weapons\\HydraliskImpact\\HydraliskImpact.mdl"
    set thistype.SPECIAL_EFFECT_SCALE[1] = 0.5
    set thistype.INTERVAL[1] = 0.035
    set thistype.SPEED[1] = 500
    set thistype.MAX_LENGTH[1] = 1300
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.CHEST
endmethod