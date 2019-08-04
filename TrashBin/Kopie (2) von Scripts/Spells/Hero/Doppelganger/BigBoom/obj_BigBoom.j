static integer array IGNITE_DURATION
static integer array DAMAGE
    
static method Init_obj_BigBoom takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABiB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Big Boom")
    call SpellObjectCreation.TEMP.SetOrder("mirrorimage")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT_OR_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 300)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 50)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSelfDestruct.blp")
    
    set thistype.IGNITE_DURATION[1] = 10
    set thistype.DAMAGE[1] = 100
endmethod