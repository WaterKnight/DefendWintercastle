static real array ILLUSION_DAMAGE_FACTOR
static integer array DURATION
static integer array MIN_RANGE
static string array ILLUSION_DEATH_EFFECT_PATH
    
static method Init_obj_Doppelganger takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ADoG')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Doppelganger")
    call SpellObjectCreation.TEMP.SetOrder("mirrorimage")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 10)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 10)
    call SpellObjectCreation.TEMP.SetManaCost(3, 50)
    call SpellObjectCreation.TEMP.SetRange(3, 500)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvengingWatcher.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FDG0', 3, 'CDG0')
    
    set thistype.ILLUSION_DAMAGE_FACTOR[1] = 0.3
    set thistype.DURATION[1] = 30
    set thistype.MIN_RANGE[1] = 200
    set thistype.ILLUSION_DEATH_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    set thistype.ILLUSION_DAMAGE_FACTOR[2] = 0.5
    set thistype.DURATION[2] = 30
    set thistype.MIN_RANGE[2] = 200
    set thistype.ILLUSION_DEATH_EFFECT_PATH[2] = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    set thistype.ILLUSION_DAMAGE_FACTOR[3] = 0.7
    set thistype.DURATION[3] = 30
    set thistype.MIN_RANGE[3] = 200
    set thistype.ILLUSION_DEATH_EFFECT_PATH[3] = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
endmethod