static real array INTERVAL
static integer array MAX_DAMAGE
    
static method Init_obj_Cleavage takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AClv')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Cleavage")
    call SpellObjectCreation.TEMP.SetOrder("evileye")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 7)
    call SpellObjectCreation.TEMP.SetManaCost(1, 60)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNShockWave.blp")
    
    set thistype.INTERVAL[1] = 0.035
    set thistype.MAX_DAMAGE[1] = 700
endmethod