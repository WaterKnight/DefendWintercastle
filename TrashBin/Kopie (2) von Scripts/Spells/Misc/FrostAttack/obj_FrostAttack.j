static integer array DURATION
    
static method Init_obj_FrostAttack takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFrA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(6)
    call SpellObjectCreation.TEMP.SetName("Frost Attack")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 140)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 140)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 140)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 140)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 140)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(6, 140)
    call SpellObjectCreation.TEMP.SetCastTime(6, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(6, 0)
    call SpellObjectCreation.TEMP.SetCooldown(6, 0)
    call SpellObjectCreation.TEMP.SetManaCost(6, 0)
    call SpellObjectCreation.TEMP.SetRange(6, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\PassiveButtons\\PASBTNFreezingBreath.blp")
    
    set thistype.DURATION[1] = 2
    set thistype.DURATION[2] = 2.5
    set thistype.DURATION[3] = 3
    set thistype.DURATION[4] = 3.5
    set thistype.DURATION[5] = 4
    set thistype.DURATION[6] = 4.5
endmethod