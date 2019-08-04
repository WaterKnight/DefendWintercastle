static string array CASTER_ARRIVAL_EFFECT_PATH
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
static integer array MAX_OFFSET
static integer array DELAY
static string array CASTER_ARRIVAL_EFFECT_ATTACH_POINT
    
static method Init_obj_TeleportScroll takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('ATpS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.ITEM)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("Teleport Scroll")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_POINT_OR_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 4)
    call SpellObjectCreation.TEMP.SetCooldown(1, 30)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.CASTER_ARRIVAL_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.MAX_OFFSET[1] = 1024
    set thistype.DELAY[1] = 4
    set thistype.CASTER_ARRIVAL_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
endmethod