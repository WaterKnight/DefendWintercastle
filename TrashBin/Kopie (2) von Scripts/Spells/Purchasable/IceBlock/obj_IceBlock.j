static integer array LIFE_REGEN_INCREMENT
static integer array DURATION
    
static method Init_obj_IceBlock takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AIcB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Ice Block")
    call SpellObjectCreation.TEMP.SetOrder("hex")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 30)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 15)
    call SpellObjectCreation.TEMP.SetManaCost(2, 35)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 15)
    call SpellObjectCreation.TEMP.SetManaCost(3, 40)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 15)
    call SpellObjectCreation.TEMP.SetManaCost(4, 45)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 15)
    call SpellObjectCreation.TEMP.SetManaCost(5, 50)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIcyTreasureBox.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FIB0', 5, 'CIB0')
    
    set thistype.LIFE_REGEN_INCREMENT[1] = 5
    set thistype.DURATION[1] = 5
    set thistype.LIFE_REGEN_INCREMENT[2] = 10
    set thistype.DURATION[2] = 5.5
    set thistype.LIFE_REGEN_INCREMENT[3] = 15
    set thistype.DURATION[3] = 6
    set thistype.LIFE_REGEN_INCREMENT[4] = 20
    set thistype.DURATION[4] = 6.5
    set thistype.LIFE_REGEN_INCREMENT[5] = 25
    set thistype.DURATION[5] = 7
endmethod