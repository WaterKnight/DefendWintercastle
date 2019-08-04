static integer array HERO_DURATION
static integer array DURATION
    
static method Init_obj_DarkAttack takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ADaA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(6)
    call SpellObjectCreation.TEMP.SetName("Dark Attack")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(6, 0)
    call SpellObjectCreation.TEMP.SetCastTime(6, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(6, 0)
    call SpellObjectCreation.TEMP.SetCooldown(6, 0)
    call SpellObjectCreation.TEMP.SetManaCost(6, 0)
    call SpellObjectCreation.TEMP.SetRange(6, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp")
    
    set thistype.HERO_DURATION[1] = 3
    set thistype.DURATION[1] = 6
    set thistype.HERO_DURATION[2] = 3
    set thistype.DURATION[2] = 6
    set thistype.HERO_DURATION[3] = 3
    set thistype.DURATION[3] = 6
    set thistype.HERO_DURATION[4] = 3
    set thistype.DURATION[4] = 6
    set thistype.HERO_DURATION[5] = 3
    set thistype.DURATION[5] = 6
    set thistype.HERO_DURATION[6] = 3
    set thistype.DURATION[6] = 6
endmethod