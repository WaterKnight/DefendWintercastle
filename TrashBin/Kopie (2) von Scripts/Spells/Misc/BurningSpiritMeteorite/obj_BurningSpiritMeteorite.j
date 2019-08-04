static real array SPEED_RELATIVE_INCREMENT
static integer array DURATION
static real array ATTACK_RATE_INCREMENT
static real array CRITICAL_INCREMENT
    
static method Init_obj_BurningSpiritMeteorite takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABuM')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Burning Spirit (Meteorite)")
    call SpellObjectCreation.TEMP.SetOrder("bloodlust")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 60)
    call SpellObjectCreation.TEMP.SetManaCost(1, 60)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp")
    
    set thistype.SPEED_RELATIVE_INCREMENT[1] = 0.25
    set thistype.DURATION[1] = 20
    set thistype.ATTACK_RATE_INCREMENT[1] = 0.25
    set thistype.CRITICAL_INCREMENT[1] = 0.25
endmethod