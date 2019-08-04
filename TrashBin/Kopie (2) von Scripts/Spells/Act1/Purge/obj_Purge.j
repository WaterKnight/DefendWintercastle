static real array SPEED_INCREMENT
static integer array DURATION
static integer array INTERVALS_AMOUNT
    
static method Init_obj_Purge takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('APur')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Purge")
    call SpellObjectCreation.TEMP.SetOrder("purge")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 8)
    call SpellObjectCreation.TEMP.SetManaCost(1, 90)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPurge.blp")
    
    set thistype.SPEED_INCREMENT[1] = -0.7
    set thistype.DURATION[1] = 6
    set thistype.INTERVALS_AMOUNT[1] = 5
endmethod