static integer array SPEED_INCREMENT
static integer array DURATION
static integer array CRITICAL_INCREMENT
    
static method Init_obj_Boost takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABoo')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Boost")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 18)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEtherealFormOn.blp")
    
    set thistype.SPEED_INCREMENT[1] = 150
    set thistype.DURATION[1] = 3
    set thistype.CRITICAL_INCREMENT[1] = 200
endmethod