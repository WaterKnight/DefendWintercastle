static integer array STUN_DURATION
static integer array DAMAGE
    
static method Init_obj_ArcticBlink takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AArB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Arctic Blink")
    call SpellObjectCreation.TEMP.SetOrder("thunderbolt")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 9)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 9)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 9)
    call SpellObjectCreation.TEMP.SetManaCost(3, 60)
    call SpellObjectCreation.TEMP.SetRange(3, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 9)
    call SpellObjectCreation.TEMP.SetManaCost(4, 70)
    call SpellObjectCreation.TEMP.SetRange(4, 800)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 9)
    call SpellObjectCreation.TEMP.SetManaCost(5, 80)
    call SpellObjectCreation.TEMP.SetRange(5, 800)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBearBlink.blp")
    
    set thistype.STUN_DURATION[1] = 2
    set thistype.DAMAGE[1] = 30
    set thistype.STUN_DURATION[2] = 2
    set thistype.DAMAGE[2] = 40
    set thistype.STUN_DURATION[3] = 2
    set thistype.DAMAGE[3] = 50
    set thistype.STUN_DURATION[4] = 2
    set thistype.DAMAGE[4] = 60
    set thistype.STUN_DURATION[5] = 2
    set thistype.DAMAGE[5] = 70
endmethod