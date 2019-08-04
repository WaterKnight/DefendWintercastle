static real array INTERVAL
static integer array DAMAGE_PER_SECOND
static integer array DURATION
    
static method Init_obj_LightningShield takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ALiS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Lightning Shield")
    call SpellObjectCreation.TEMP.SetOrder("lightningshield")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 130)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 25)
    call SpellObjectCreation.TEMP.SetManaCost(1, 120)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
    
    set thistype.INTERVAL[1] = 0.5
    set thistype.DAMAGE_PER_SECOND[1] = 20
    set thistype.DURATION[1] = 20
endmethod