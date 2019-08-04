static integer array MAX_LENGTH
static integer array SPEED
static integer array WIDTH_END
static integer array WIDTH_START
static integer array DAMAGE
    
static method Init_obj_ChillyBreath takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AChB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Chilly Breath")
    call SpellObjectCreation.TEMP.SetOrder("breathoffrost")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 14)
    call SpellObjectCreation.TEMP.SetManaCost(1, 20)
    call SpellObjectCreation.TEMP.SetRange(1, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 14)
    call SpellObjectCreation.TEMP.SetManaCost(2, 30)
    call SpellObjectCreation.TEMP.SetRange(2, 550)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 14)
    call SpellObjectCreation.TEMP.SetManaCost(3, 40)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 14)
    call SpellObjectCreation.TEMP.SetManaCost(4, 50)
    call SpellObjectCreation.TEMP.SetRange(4, 650)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 14)
    call SpellObjectCreation.TEMP.SetManaCost(5, 60)
    call SpellObjectCreation.TEMP.SetRange(5, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FCB0', 5, 'CCB0')
    
    set thistype.MAX_LENGTH[1] = 600
    set thistype.SPEED[1] = 650
    set thistype.WIDTH_END[1] = 300
    set thistype.WIDTH_START[1] = 0
    set thistype.DAMAGE[1] = 35
    set thistype.MAX_LENGTH[2] = 650
    set thistype.SPEED[2] = 650
    set thistype.WIDTH_END[2] = 300
    set thistype.WIDTH_START[2] = 0
    set thistype.DAMAGE[2] = 60
    set thistype.MAX_LENGTH[3] = 700
    set thistype.SPEED[3] = 650
    set thistype.WIDTH_END[3] = 300
    set thistype.WIDTH_START[3] = 0
    set thistype.DAMAGE[3] = 85
    set thistype.MAX_LENGTH[4] = 750
    set thistype.SPEED[4] = 650
    set thistype.WIDTH_END[4] = 300
    set thistype.WIDTH_START[4] = 0
    set thistype.DAMAGE[4] = 110
    set thistype.MAX_LENGTH[5] = 800
    set thistype.SPEED[5] = 650
    set thistype.WIDTH_END[5] = 300
    set thistype.WIDTH_START[5] = 0
    set thistype.DAMAGE[5] = 135
endmethod