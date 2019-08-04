static real array INTERVAL
    
static method Init_obj_Blizzard takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABlz')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Blizzard")
    call SpellObjectCreation.TEMP.SetOrder("blizzard")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell,channel")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 275)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 325)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 5)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 55)
    call SpellObjectCreation.TEMP.SetRange(2, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 375)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 5)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 70)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 425)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 5)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 85)
    call SpellObjectCreation.TEMP.SetRange(4, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 475)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 5)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 100)
    call SpellObjectCreation.TEMP.SetRange(5, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FBl0', 5, 'CBl0')
    
    set thistype.INTERVAL[1] = 0.75
    set thistype.INTERVAL[2] = 0.75
    set thistype.INTERVAL[3] = 0.75
    set thistype.INTERVAL[4] = 0.75
    set thistype.INTERVAL[5] = 0.75
endmethod