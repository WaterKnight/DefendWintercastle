
static method Init_obj_LunarRestoration takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ALuR')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Lunar Restoration")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 100)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNElunesBlessing.blp")
    
endmethod