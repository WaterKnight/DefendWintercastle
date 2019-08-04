static string array CASTER_EFFECT_PATH
static string array CASTER_EFFECT_ATTACH_POINT
static integer array REFRESHED_MANA
    
static method Init_obj_IceTea takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AIcT')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(3)
    call SpellObjectCreation.TEMP.SetName("Ice Tea")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 0)
    call SpellObjectCreation.TEMP.SetCooldown(2, 20)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 750)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 0)
    call SpellObjectCreation.TEMP.SetCooldown(3, 20)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.REFRESHED_MANA[1] = 200
    set thistype.CASTER_EFFECT_PATH[2] = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
    set thistype.CASTER_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.REFRESHED_MANA[2] = 350
    set thistype.CASTER_EFFECT_PATH[3] = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
    set thistype.CASTER_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.REFRESHED_MANA[3] = 500
endmethod