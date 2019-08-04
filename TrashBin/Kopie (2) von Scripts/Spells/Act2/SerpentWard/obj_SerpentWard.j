static string array SUMMON_UNIT_TYPE
static integer array DURATION
static integer array SUMMON_AMOUNT
    
static method Init_obj_SerpentWard takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ASeW')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Serpent Ward")
    call SpellObjectCreation.TEMP.SetOrder("ward")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 15)
    call SpellObjectCreation.TEMP.SetManaCost(1, 55)
    call SpellObjectCreation.TEMP.SetRange(1, 550)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSerpentWard.blp")
    
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.SERPENT_WARD
    set thistype.DURATION[1] = 20
    set thistype.SUMMON_AMOUNT[1] = 3
endmethod