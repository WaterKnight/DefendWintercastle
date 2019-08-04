static integer array HEAL
static string array CASTER_EFFECT_ATTACH_POINT
static integer array INTERVAL
static integer array DURATION
static string array CASTER_EFFECT_PATH
    
static method Init_obj_Meat takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AMea')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Meat")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 20)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.HEAL[1] = 300
    set thistype.CASTER_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.INTERVAL[1] = 1
    set thistype.DURATION[1] = 10
    set thistype.CASTER_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
endmethod