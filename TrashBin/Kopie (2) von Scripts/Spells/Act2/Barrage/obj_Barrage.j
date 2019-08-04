static integer array OFFSET
static integer array COLOR_FADE_DURATION
static integer array DAMAGE_PER_SECOND
static integer array RED_INCREMENT
static real array INTERVAL
static integer array BLUE_INCREMENT
static integer array ALPHA_INCREMENT
static integer array GREEN_INCREMENT
    
static method Init_obj_Barrage takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ABag')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Barrage")
    call SpellObjectCreation.TEMP.SetOrder("thunderbolt")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 250)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 12)
    call SpellObjectCreation.TEMP.SetManaCost(1, 80)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFlakCannons.blp")
    
    set thistype.OFFSET[1] = 50
    set thistype.COLOR_FADE_DURATION[1] = 2
    set thistype.DAMAGE_PER_SECOND[1] = 100
    set thistype.RED_INCREMENT[1] = 0
    set thistype.INTERVAL[1] = 0.3
    set thistype.BLUE_INCREMENT[1] = 0
    set thistype.ALPHA_INCREMENT[1] = 0
    set thistype.GREEN_INCREMENT[1] = 0
endmethod