//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseInclude.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_base.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\obj_baseNorm.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_baseInclude)
    call Spell.AddInit(function thistype.Init_obj_base)
    call Spell.AddInit(function thistype.Init_obj_baseNorm)
endmethod