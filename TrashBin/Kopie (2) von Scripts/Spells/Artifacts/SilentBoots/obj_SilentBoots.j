static string array CASTER_EFFECT_PATH
static integer array DURATION
static string array CASTER_EFFECT_ATTACH_POINT
static integer array MOVE_SPEED_INCREMENT
    
static method Init_obj_SilentBoots takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASiB')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ARTIFACT)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Silent Boots")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 25)
    call SpellObjectCreation.TEMP.SetManaCost(1, 50)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 22)
    call SpellObjectCreation.TEMP.SetManaCost(2, 50)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 19)
    call SpellObjectCreation.TEMP.SetManaCost(3, 50)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 0)
    call SpellObjectCreation.TEMP.SetCooldown(4, 16)
    call SpellObjectCreation.TEMP.SetManaCost(4, 50)
    call SpellObjectCreation.TEMP.SetRange(4, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 0)
    call SpellObjectCreation.TEMP.SetCooldown(5, 13)
    call SpellObjectCreation.TEMP.SetManaCost(5, 50)
    call SpellObjectCreation.TEMP.SetRange(5, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp")
    
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
    set thistype.DURATION[1] = 5
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.MOVE_SPEED_INCREMENT[1] = 50
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
    set thistype.DURATION[2] = 6
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.MOVE_SPEED_INCREMENT[2] = 80
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
    set thistype.DURATION[3] = 7
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.MOVE_SPEED_INCREMENT[3] = 110
    set thistype.CASTER_EFFECT_PATH[4] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
    set thistype.DURATION[4] = 8
    set thistype.CASTER_EFFECT_ATTACH_POINT[4] = AttachPoint.ORIGIN
    set thistype.MOVE_SPEED_INCREMENT[4] = 140
    set thistype.CASTER_EFFECT_PATH[5] = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
    set thistype.DURATION[5] = 9
    set thistype.CASTER_EFFECT_ATTACH_POINT[5] = AttachPoint.ORIGIN
    set thistype.MOVE_SPEED_INCREMENT[5] = 170
endmethod