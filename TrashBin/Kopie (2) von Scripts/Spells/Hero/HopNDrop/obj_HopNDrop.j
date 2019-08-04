static integer array HEIGHT
static integer array DURATION
static integer array MAX_LENGTH
static integer array FLOOR_TOLERANCE
    
static method Init_obj_HopNDrop takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHop')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_SECOND)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Hop'n'Drop")
    call SpellObjectCreation.TEMP.SetOrder("stasistrap")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 22)
    call SpellObjectCreation.TEMP.SetManaCost(1, 120)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 20)
    call SpellObjectCreation.TEMP.SetManaCost(2, 140)
    call SpellObjectCreation.TEMP.SetRange(2, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 18)
    call SpellObjectCreation.TEMP.SetManaCost(3, 160)
    call SpellObjectCreation.TEMP.SetRange(3, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 16)
    call SpellObjectCreation.TEMP.SetManaCost(4, 180)
    call SpellObjectCreation.TEMP.SetRange(4, 900)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 14)
    call SpellObjectCreation.TEMP.SetManaCost(5, 200)
    call SpellObjectCreation.TEMP.SetRange(5, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGoblinLandMine.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FHD0', 5, 'CHD0')
    
    set thistype.HEIGHT[1] = 500
    set thistype.DURATION[1] = 1
    set thistype.MAX_LENGTH[1] = 900
    set thistype.FLOOR_TOLERANCE[1] = 1
    set thistype.HEIGHT[2] = 500
    set thistype.DURATION[2] = 1
    set thistype.MAX_LENGTH[2] = 900
    set thistype.FLOOR_TOLERANCE[2] = 1
    set thistype.HEIGHT[3] = 500
    set thistype.DURATION[3] = 1
    set thistype.MAX_LENGTH[3] = 900
    set thistype.FLOOR_TOLERANCE[3] = 1
    set thistype.HEIGHT[4] = 500
    set thistype.DURATION[4] = 1
    set thistype.MAX_LENGTH[4] = 900
    set thistype.FLOOR_TOLERANCE[4] = 1
    set thistype.HEIGHT[5] = 500
    set thistype.DURATION[5] = 1
    set thistype.MAX_LENGTH[5] = 900
    set thistype.FLOOR_TOLERANCE[5] = 1
endmethod