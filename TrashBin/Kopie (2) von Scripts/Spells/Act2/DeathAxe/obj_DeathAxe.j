static integer array DISARM_DURATION
static integer array DELAY
static integer array DAMAGE
    
static method Init_obj_DeathAxe takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ADeA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Death Axe")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 80)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSpiritWalkerMasterTraining.blp")
    
    set thistype.DISARM_DURATION[1] = 3
    set thistype.DELAY[1] = 1
    set thistype.DAMAGE[1] = 70
endmethod