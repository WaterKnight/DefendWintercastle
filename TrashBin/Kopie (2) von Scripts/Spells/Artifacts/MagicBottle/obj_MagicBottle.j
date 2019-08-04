static integer array STAMINA_INCREMENT
static real array STAMINA_RELATIVE_INCREMENT
    
static method Init_obj_MagicBottle takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMaB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Magic Bottle")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 16)
    call SpellObjectCreation.TEMP.SetManaCost(1, 55)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 16)
    call SpellObjectCreation.TEMP.SetManaCost(2, 75)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 16)
    call SpellObjectCreation.TEMP.SetManaCost(3, 95)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 16)
    call SpellObjectCreation.TEMP.SetManaCost(4, 115)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 16)
    call SpellObjectCreation.TEMP.SetManaCost(5, 125)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfOmniscience.blp")
    
    set thistype.STAMINA_INCREMENT[1] = 25
    set thistype.STAMINA_RELATIVE_INCREMENT[1] = 0.05
    set thistype.STAMINA_INCREMENT[2] = 35
    set thistype.STAMINA_RELATIVE_INCREMENT[2] = 0.05
    set thistype.STAMINA_INCREMENT[3] = 45
    set thistype.STAMINA_RELATIVE_INCREMENT[3] = 0.05
    set thistype.STAMINA_INCREMENT[4] = 55
    set thistype.STAMINA_RELATIVE_INCREMENT[4] = 0.05
    set thistype.STAMINA_INCREMENT[5] = 60
    set thistype.STAMINA_RELATIVE_INCREMENT[5] = 0.05
endmethod