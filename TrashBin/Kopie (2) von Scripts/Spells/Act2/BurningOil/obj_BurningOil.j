static real array INTERVAL
static integer array DAMAGE_PER_SECOND
static integer array DURATION
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_BurningOil takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABuO')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Burning Oil")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 140)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNFireRocks.blp")
    
    set thistype.INTERVAL[1] = 0.75
    set thistype.DAMAGE_PER_SECOND[1] = 26
    set thistype.DURATION[1] = 6
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Orc\\LiquidFire\\Liquidfire.mdl"
endmethod