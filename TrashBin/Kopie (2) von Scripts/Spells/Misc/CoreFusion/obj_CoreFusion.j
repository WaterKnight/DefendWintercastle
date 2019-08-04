static real array HEAL_FACTOR
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_CoreFusion takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ACoF')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Core Fusion")
    call SpellObjectCreation.TEMP.SetOrder("deathanddecay")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 150)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNUsedSoulGem.blp")
    
    set thistype.HEAL_FACTOR[1] = 0.2
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
endmethod