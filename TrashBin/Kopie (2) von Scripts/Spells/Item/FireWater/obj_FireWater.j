static string array CASTER_EFFECT_PATH
static string array CASTER_EFFECT_ATTACH_POINT
static integer array REFRESHED_MANA
    
static method Init_obj_FireWater takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AFiW')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Fire Water")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 70)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 40)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.REFRESHED_MANA[1] = 750
endmethod