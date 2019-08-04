static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
static integer array DURATION
static integer array HERO_DURATION
static integer array DAMAGE
    
static method Init_obj_IceArrows takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AIcA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Ice Arrows")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 20)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNColdArrowsOn.blp")
    
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.DURATION[1] = 6
    set thistype.HERO_DURATION[1] = 3
    set thistype.DAMAGE[1] = 25
endmethod