static integer array LIFE_INCREMENT
    
static method Init_obj_GarmentsOfTheSalamander takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASam')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Garments of the Salamander")
    call SpellObjectCreation.TEMP.SetOrder("evileye")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 3)
    call SpellObjectCreation.TEMP.SetManaCost(1, 15)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 3)
    call SpellObjectCreation.TEMP.SetManaCost(2, 15)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 3)
    call SpellObjectCreation.TEMP.SetManaCost(3, 15)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 3)
    call SpellObjectCreation.TEMP.SetManaCost(4, 15)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 3)
    call SpellObjectCreation.TEMP.SetManaCost(5, 15)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThunderLizardSalamander.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSa0', 5, 'CSa0')
    
    set thistype.LIFE_INCREMENT[1] = 5
    set thistype.LIFE_INCREMENT[2] = 8
    set thistype.LIFE_INCREMENT[3] = 11
    set thistype.LIFE_INCREMENT[4] = 14
    set thistype.LIFE_INCREMENT[5] = 17
endmethod