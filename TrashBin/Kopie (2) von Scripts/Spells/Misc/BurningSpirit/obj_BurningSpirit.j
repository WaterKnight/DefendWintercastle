static real array SPEED_RELATIVE_INCREMENT
static integer array DURATION
static real array ATTACK_RATE_INCREMENT
static real array CRITICAL_INCREMENT
    
static method Init_obj_BurningSpirit takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABuT')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Burning Spirit")
    call SpellObjectCreation.TEMP.SetOrder("bloodlust")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 10)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.25
    set thistype.DURATION[1] = 20
    set thistype.ATTACK_RATE_INCREMENT[1] = 0.25
    set thistype.CRITICAL_INCREMENT[1] = 0.25
endmethod