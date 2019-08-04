static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_ScrollOfProtection takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AScP')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Scroll of Protection")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 600)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 40)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl"
endmethod