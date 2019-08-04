static real array MANA_FACTOR
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_RefreshMana takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AReM')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Refresh Mana")
    call SpellObjectCreation.TEMP.SetOrder("replenishmana")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 30)
    call SpellObjectCreation.TEMP.SetManaCost(1, 90)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNManaRecharge.blp")
    
    set thistype.MANA_FACTOR[1] = 0.5
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
endmethod