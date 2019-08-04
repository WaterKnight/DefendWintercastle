static integer array SPAWN_OFFSET
static integer array SPAWN_ANGLE_MAX_ADD
static integer array MAX_LENGTH
static integer array SPEED
static integer array SPAWN_AMOUNT
    
static method Init_obj_SnowySphere takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASnS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.PURCHASABLE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Snowy Sphere")
    call SpellObjectCreation.TEMP.SetOrder("acidbomb")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 75)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 75)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 15)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 75)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 15)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 75)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 15)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 500)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 75)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 15)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 500)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNTornado.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FSS0', 5, 'CSS0')
    
    set thistype.SPAWN_OFFSET[1] = -50
    set thistype.SPAWN_ANGLE_MAX_ADD[1] = 14
    set thistype.MAX_LENGTH[1] = 800
    set thistype.SPEED[1] = 800
    set thistype.SPAWN_AMOUNT[1] = 20
    set thistype.SPAWN_OFFSET[2] = -50
    set thistype.SPAWN_ANGLE_MAX_ADD[2] = 14
    set thistype.MAX_LENGTH[2] = 800
    set thistype.SPEED[2] = 800
    set thistype.SPAWN_AMOUNT[2] = 30
    set thistype.SPAWN_OFFSET[3] = -50
    set thistype.SPAWN_ANGLE_MAX_ADD[3] = 14
    set thistype.MAX_LENGTH[3] = 800
    set thistype.SPEED[3] = 800
    set thistype.SPAWN_AMOUNT[3] = 40
    set thistype.SPAWN_OFFSET[4] = -50
    set thistype.SPAWN_ANGLE_MAX_ADD[4] = 14
    set thistype.MAX_LENGTH[4] = 800
    set thistype.SPEED[4] = 800
    set thistype.SPAWN_AMOUNT[4] = 50
    set thistype.SPAWN_OFFSET[5] = -50
    set thistype.SPAWN_ANGLE_MAX_ADD[5] = 14
    set thistype.MAX_LENGTH[5] = 800
    set thistype.SPEED[5] = 800
    set thistype.SPAWN_AMOUNT[5] = 60
endmethod