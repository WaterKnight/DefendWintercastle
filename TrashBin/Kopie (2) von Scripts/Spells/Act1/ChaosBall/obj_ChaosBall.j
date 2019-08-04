static integer array OFFSET_Z
static integer array RANGE_TOLERANCE
static integer array DURATION
static string array SPECIAL_EFFECT_PATH
static integer array DAMAGE
    
static method Init_obj_ChaosBall takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AKao')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Chaos Ball")
    call SpellObjectCreation.TEMP.SetOrder("deathcoil")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 100)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0.75)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 100)
    call SpellObjectCreation.TEMP.SetRange(1, 700)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOrbOfDeath.blp")
    
    set thistype.OFFSET_Z[1] = 80
    set thistype.RANGE_TOLERANCE[1] = 300
    set thistype.DURATION[1] = 3
    set thistype.SPECIAL_EFFECT_PATH[1] = "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl"
    set thistype.DAMAGE[1] = 65
endmethod