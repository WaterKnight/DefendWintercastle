static string array LEARN_RAW
static string array LEARN_BUTTON_POS_Y
static string array LEARN_HOTKEY
static string array LEARN_UBER_TOOLTIP
static string array LEARN_ICON
static string array LEARN_BUTTON_POS_X
static string array LEARN_TOOLTIP
    
static method Init_obj_baseInclude takes nothing returns nothing
    set SpellObjectCreation.TEMP = Spell.CreateFromSelf('')
    
    call SpellObjectCreation.TEMP.SetClass(SpellClass.NORMAL)
    call SpellObjectCreation.TEMP.SetLevelsAmount(1)
    call SpellObjectCreation.TEMP.SetName("")
    call SpellObjectCreation.TEMP.SetAnimation("spell")
    call SpellObjectCreation.TEMP.SetAreaRange(1, 0)
    call SpellObjectCreation.TEMP.SetCastTime(1, 0)
    call SpellObjectCreation.TEMP.SetChannelTime(1, 0)
    call SpellObjectCreation.TEMP.SetCooldown(1, 0)
    call SpellObjectCreation.TEMP.SetManaCost(1, 0)
    call SpellObjectCreation.TEMP.SetRange(1, 750)
    call SpellObjectCreation.TEMP.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
endmethod