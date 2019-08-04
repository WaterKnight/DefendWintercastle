//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseInclude.j
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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseInclude.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseNorm.j
static Spell BASE_NORM
    
    
static method Init_obj_baseNorm takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseNorm.wc3spell")
    set thistype.BASE_NORM = Spell.CreateHidden(thistype.NAME + " (baseNorm)")
    
    call thistype.BASE_NORM.SetLevelsAmount(5)
    call thistype.BASE_NORM.SetAnimation("spell")
    call thistype.BASE_NORM.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\baseNorm.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseNorm.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_base.j
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
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_base.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_buff.j
static Buff BUFF
    
static string SFX0
static string SFX0_LEVEL
static string SFX0_ATTACH_PT
    
static method Init_obj_buff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\buff.wc3buff")
    set thistype.BUFF = Buff.CreateHidden(thistype.NAME + " (buff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\buff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_buff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_baseInclude)
    call Spell.AddInit(function thistype.Init_obj_baseNorm)
    call Spell.AddInit(function thistype.Init_obj_base)
    call Buff.AddInit(function thistype.Init_obj_buff)
endmethod