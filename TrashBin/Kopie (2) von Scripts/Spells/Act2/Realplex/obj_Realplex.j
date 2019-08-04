static integer array OFFSET
static integer array ILLUSIONS_AMOUNT
static real array MOVE_DURATION
static string array CASTER_EFFECT_PATH
static integer array DURATION
static string array CASTER_EFFECT_ATTACH_POINT
static string array DEATH_EFFECT_PATH
    
static method Init_obj_Realplex takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AReP')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Realplex")
    call SpellObjectCreation.TEMP.SetOrder("mirrorimage")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNInvisibility.blp")
    
    set thistype.OFFSET[1] = 100
    set thistype.ILLUSIONS_AMOUNT[1] = 2
    set thistype.MOVE_DURATION[1] = 0.5
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl"
    set thistype.DURATION[1] = 10
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.OVERHEAD
    set thistype.DEATH_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
endmethod