static integer array DAMAGE
static integer array MAX_TARGETS_AMOUNT
    
static method Init_obj_Lapidation takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ALap')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Lapidation")
    call SpellObjectCreation.TEMP.SetOrder("sleep")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 700)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 80)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGolemStormBolt.blp")
    
    set thistype.DAMAGE[1] = 100
    set thistype.MAX_TARGETS_AMOUNT[1] = 10
endmethod