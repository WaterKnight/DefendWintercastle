static string array SUMMON_UNIT_TYPE
static integer array DURATION
static integer array SUMMONS_AMOUNT
    
static method Init_obj_EyeOfTheFlame takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AEoF')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Eye of the Flame")
    call SpellObjectCreation.TEMP.SetOrder("evileye")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 550)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.EYE_OF_THE_FLAME
    set thistype.DURATION[1] = 40
    set thistype.SUMMONS_AMOUNT[1] = 1
endmethod