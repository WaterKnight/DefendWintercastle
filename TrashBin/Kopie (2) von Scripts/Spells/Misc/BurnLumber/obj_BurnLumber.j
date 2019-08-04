static integer array HEAL_MANA
static integer array HEAL
    
static method Init_obj_BurnLumber takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABuL')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Burn Lumber")
    call SpellObjectCreation.TEMP.SetOrder("neutralspell")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOrcLumberUpgradeTwo.blp")
    
    set thistype.HEAL_MANA[1] = 50
    set thistype.HEAL[1] = 50
endmethod