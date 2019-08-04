static integer array TARGETS_AMOUNT
    
static method Init_obj_Severance takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASev')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Severance")
    call SpellObjectCreation.TEMP.SetOrder("howlofterror")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 500)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 12)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 525)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 500)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 12)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 525)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 500)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 12)
    call SpellObjectCreation.TEMP.SetManaCost(3, 65)
    call SpellObjectCreation.TEMP.SetRange(3, 525)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 500)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 12)
    call SpellObjectCreation.TEMP.SetManaCost(4, 85)
    call SpellObjectCreation.TEMP.SetRange(4, 525)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 500)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 12)
    call SpellObjectCreation.TEMP.SetManaCost(5, 110)
    call SpellObjectCreation.TEMP.SetRange(5, 525)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSe0', 5, 'CSe0')
    
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGETS_AMOUNT[2] = 3
    set thistype.TARGETS_AMOUNT[3] = 4
    set thistype.TARGETS_AMOUNT[4] = 4
    set thistype.TARGETS_AMOUNT[5] = 5
endmethod