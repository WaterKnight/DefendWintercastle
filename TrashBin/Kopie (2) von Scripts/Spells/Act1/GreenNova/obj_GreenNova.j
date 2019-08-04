static integer array SPECIAL_EFFECT_PERIMETER_INTERVAL
static integer array MAX_RADIUS
static integer array WAVES_AMOUNT
static real array INTERVAL
static string array SPECIAL_EFFECT_PATH
    
static method Init_obj_GreenNova takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AGrN')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Green Nova")
    call SpellObjectCreation.TEMP.SetOrder("entanglingroots")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_IMMEDIATE)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 400)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    
    set thistype.SPECIAL_EFFECT_PERIMETER_INTERVAL[1] = 200
    set thistype.MAX_RADIUS[1] = 600
    set thistype.WAVES_AMOUNT[1] = 10
    set thistype.INTERVAL[1] = 0.125
    set thistype.SPECIAL_EFFECT_PATH[1] = "Abilities\\\\Spells\\\\NightElf\\\\EntanglingRoots\\\\EntanglingRootsTarget.mdl"
endmethod