static real array INTERVAL
static integer array DAMAGE_PER_SECOND
static string array EFFECT_LIGHTNING_PATH
    
static method Init_obj_Lariat takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('AWBS')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(5)
    call SpellObjectCreation.TEMP.SetName("Water Bindings Lariat")
    call SpellObjectCreation.TEMP.SetOrder("summongrizzly")
    call SpellObjectCreation.TEMP.SetTargetType(SpellObjectCreation.TARGET_TYPE_UNIT)
    call SpellObjectCreation.TEMP.SetAnimation("attack")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 5)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(2, 0)
    call SpellObjectCreation.TEMP.SetCastTime(2, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(2, 5)
    call SpellObjectCreation.TEMP.SetCooldown(2, 0)
    call SpellObjectCreation.TEMP.SetManaCost(2, 0)
    call SpellObjectCreation.TEMP.SetRange(2, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(3, 0)
    call SpellObjectCreation.TEMP.SetCastTime(3, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(3, 5)
    call SpellObjectCreation.TEMP.SetCooldown(3, 0)
    call SpellObjectCreation.TEMP.SetManaCost(3, 0)
    call SpellObjectCreation.TEMP.SetRange(3, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(4, 0)
    call SpellObjectCreation.TEMP.SetCastTime(4, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(4, 5)
    call SpellObjectCreation.TEMP.SetCooldown(4, 0)
    call SpellObjectCreation.TEMP.SetManaCost(4, 0)
    call SpellObjectCreation.TEMP.SetRange(4, 99999)
    call SpellObjectCreation.TEMP.SetAreaRange(5, 0)
    call SpellObjectCreation.TEMP.SetCastTime(5, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(5, 5)
    call SpellObjectCreation.TEMP.SetCooldown(5, 0)
    call SpellObjectCreation.TEMP.SetManaCost(5, 0)
    call SpellObjectCreation.TEMP.SetRange(5, 99999)
    call SpellObjectCreation.TEMP.SetIcon("")
    
    set thistype.INTERVAL[1] = 0.25
    set thistype.DAMAGE_PER_SECOND[1] = 7
    set thistype.EFFECT_LIGHTNING_PATH[1] = "SPLK"
    set thistype.INTERVAL[2] = 0.25
    set thistype.DAMAGE_PER_SECOND[2] = 10
    set thistype.EFFECT_LIGHTNING_PATH[2] = "SPLK"
    set thistype.INTERVAL[3] = 0.25
    set thistype.DAMAGE_PER_SECOND[3] = 14
    set thistype.EFFECT_LIGHTNING_PATH[3] = "SPLK"
    set thistype.INTERVAL[4] = 0.25
    set thistype.DAMAGE_PER_SECOND[4] = 19
    set thistype.EFFECT_LIGHTNING_PATH[4] = "SPLK"
    set thistype.INTERVAL[5] = 0.25
    set thistype.DAMAGE_PER_SECOND[5] = 25
    set thistype.EFFECT_LIGHTNING_PATH[5] = "SPLK"
endmethod