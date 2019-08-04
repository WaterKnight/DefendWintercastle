static integer array HEAL
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_Heal takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AHel')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Heal")
    call SpellObjectCreation.TEMP.SetOrder("heal")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 5)
    call SpellObjectCreation.TEMP.SetManaCost(1, 40)
    call SpellObjectCreation.TEMP.SetRange(1, 900)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHeal.blp")
    
    set thistype.HEAL[1] = 50
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
endmethod