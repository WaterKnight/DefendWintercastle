static integer array POISON_DURATION
static integer array POISON_HERO_DURATION
static integer array DAMAGE
    
static method Init_obj_Vomit takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AVom')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Vomit")
    call SpellObjectCreation.TEMP.SetOrder("sanctuary")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 5)
    call SpellObjectCreation.TEMP.SetManaCost(1, 15)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 5)
    call SpellObjectCreation.TEMP.SetManaCost(2, 20)
    call SpellObjectCreation.TEMP.SetRange(2, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 5)
    call SpellObjectCreation.TEMP.SetManaCost(3, 25)
    call SpellObjectCreation.TEMP.SetRange(3, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 5)
    call SpellObjectCreation.TEMP.SetManaCost(4, 30)
    call SpellObjectCreation.TEMP.SetRange(4, 700)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 5)
    call SpellObjectCreation.TEMP.SetManaCost(5, 35)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCorrosiveBreath.blp")
    
    set thistype.POISON_DURATION[1] = 3
    set thistype.POISON_HERO_DURATION[1] = 2
    set thistype.DAMAGE[1] = 30
    set thistype.POISON_DURATION[2] = 4
    set thistype.POISON_HERO_DURATION[2] = 2
    set thistype.DAMAGE[2] = 40
    set thistype.POISON_DURATION[3] = 5
    set thistype.POISON_HERO_DURATION[3] = 2
    set thistype.DAMAGE[3] = 50
    set thistype.POISON_DURATION[4] = 6
    set thistype.POISON_HERO_DURATION[4] = 2
    set thistype.DAMAGE[4] = 60
    set thistype.POISON_DURATION[5] = 7
    set thistype.POISON_HERO_DURATION[5] = 2
    set thistype.DAMAGE[5] = 70
endmethod