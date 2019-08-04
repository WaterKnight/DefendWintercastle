static integer array INTERVALS_AMOUNT
static real array DELAY
static integer array DAMAGE_PER_MISSILE
    
static method Init_obj_FuzzyAttack takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFuA')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Fuzzy Attack")
    call SpellObjectCreation.TEMP.SetOrder("thunderbolt")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 4.25)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 150)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFurbolg.blp")
    
    set thistype.INTERVALS_AMOUNT[1] = 7
    set thistype.DELAY[1] = 2.5
    set thistype.DAMAGE_PER_MISSILE[1] = 50
endmethod