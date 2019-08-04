static Spell BASE_INCLUDE
    
static string LEARN_RAW
static string LEARN_BUTTON_POS_Y
static string LEARN_HOTKEY
static string LEARN_BUTTON_POS_X
static string LEARN_ICON
static string LEARN_TOOLTIP
static string LEARN_UBER_TOOLTIP
    
static method Init_obj_baseInclude takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseInclude.wc3spell")
    set thistype.BASE_INCLUDE = Spell.CreateHidden(thistype.NAME + " (baseInclude)")
    
    call thistype.BASE_INCLUDE.SetLevelsAmount(5)
    call thistype.BASE_INCLUDE.SetAnimation("spell")
    call thistype.BASE_INCLUDE.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseInclude.wc3spell")
    call t.Destroy()
endmethod