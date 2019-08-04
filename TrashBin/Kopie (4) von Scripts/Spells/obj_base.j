static Spell BASE
    
static string LEARN_RAW
static string LEARN_BUTTON_POS_Y
static string LEARN_HOTKEY
static string LEARN_BUTTON_POS_X
static string LEARN_ICON
static string LEARN_TOOLTIP
static string LEARN_UBER_TOOLTIP
    
static method Init_obj_base takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\base.wc3spell")
    set thistype.BASE = Spell.CreateHidden(thistype.NAME + " (base)")
    
    call thistype.BASE.SetLevelsAmount(5)
    call thistype.BASE.SetAnimation("spell")
    call thistype.BASE.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\base.wc3spell")
    call t.Destroy()
endmethod