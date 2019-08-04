static integer array DURATION
static integer array DAMAGE
    
static method Init_obj_BoomerangStone takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABoS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Boomerang Stone")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 650)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.DURATION[1] = 3
    set thistype.DAMAGE[1] = 40
endmethod