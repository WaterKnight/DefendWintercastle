static integer array INTERVAL
static integer array LIFE_ADD
static integer array DURATION
static integer array MANA_ADD
    
static method Init_obj_HerbalOintment takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHeO')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Herbal Ointment")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.INTERVAL[1] = 1
    set thistype.LIFE_ADD[1] = 200
    set thistype.DURATION[1] = 10
    set thistype.MANA_ADD[1] = 200
endmethod