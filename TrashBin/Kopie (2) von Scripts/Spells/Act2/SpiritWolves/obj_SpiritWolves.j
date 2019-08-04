static string array SUMMON_UNIT_TYPE
static integer array DURATION
static integer array SUMMON_AMOUNT
static integer array OFFSET
    
static method Init_obj_SpiritWolves takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASpW')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Spirit Wolves")
    call SpellObjectCreation.TEMP.SetOrder("spiritwolf")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 22)
    call SpellObjectCreation.TEMP.SetManaCost(1, 125)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp")
    
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.SPIRIT_WOLF
    set thistype.DURATION[1] = 40
    set thistype.SUMMON_AMOUNT[1] = 2
    set thistype.OFFSET[1] = 70
endmethod