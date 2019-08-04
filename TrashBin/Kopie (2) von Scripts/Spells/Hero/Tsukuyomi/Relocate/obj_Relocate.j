static integer array SPEED
    
static method Init_obj_Relocate takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATsR')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call SpellObjectCreation.TEMP.SetLevelsAmount(2)
    call SpellObjectCreation.TEMP.SetName("Relocate")
    call SpellObjectCreation.TEMP.SetOrder("bloodlust")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNUndeadUnLoad.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FTR0', 2, 'CTR0')
    
    set thistype.SPEED[1] = 300
    set thistype.SPEED[2] = 300
endmethod