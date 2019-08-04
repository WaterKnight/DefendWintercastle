static integer array ACCELERATION
static integer array DUMMY_UNIT_OFFSET
static integer array ANIMATION_INCREMENT
static integer array DUMMY_UNIT_DURATION
static real array EFFECT_INTERVAL
static integer array SPEED
static integer array ARRIVAL_TOLERANCE
    
static method Init_obj_PandaPaw takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('APaP')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.HERO_ULTIMATE)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Panda Paw")
    call SpellObjectCreation.TEMP.SetOrder("drunkenhaze")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("attack")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 400)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 125)
    call SpellObjectCreation.TEMP.SetRange(1, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 400)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 14)
    call SpellObjectCreation.TEMP.SetManaCost(2, 150)
    call SpellObjectCreation.TEMP.SetRange(2, 600)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 400)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 13)
    call SpellObjectCreation.TEMP.SetManaCost(3, 175)
    call SpellObjectCreation.TEMP.SetRange(3, 600)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBearForm.blp")
    
    call Hero.InitSpell(SpellObjectCreation.TEMP, 'FPP0', 3, 'CPP0')
    
    set thistype.ACCELERATION[1] = 500
    set thistype.DUMMY_UNIT_OFFSET[1] = -75
    set thistype.ANIMATION_INCREMENT[1] = 1
    set thistype.DUMMY_UNIT_DURATION[1] = 1
    set thistype.EFFECT_INTERVAL[1] = 0.125
    set thistype.SPEED[1] = 500
    set thistype.ARRIVAL_TOLERANCE[1] = 5
    set thistype.ACCELERATION[2] = 500
    set thistype.DUMMY_UNIT_OFFSET[2] = -75
    set thistype.ANIMATION_INCREMENT[2] = 1
    set thistype.DUMMY_UNIT_DURATION[2] = 1
    set thistype.EFFECT_INTERVAL[2] = 0.125
    set thistype.SPEED[2] = 500
    set thistype.ARRIVAL_TOLERANCE[2] = 5
    set thistype.ACCELERATION[3] = 500
    set thistype.DUMMY_UNIT_OFFSET[3] = -75
    set thistype.ANIMATION_INCREMENT[3] = 1
    set thistype.DUMMY_UNIT_DURATION[3] = 1
    set thistype.EFFECT_INTERVAL[3] = 0.125
    set thistype.SPEED[3] = 500
    set thistype.ARRIVAL_TOLERANCE[3] = 5
endmethod