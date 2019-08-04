//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Lapidation\obj_Lapidation.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Lapidation\obj_Buff.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Lapidation)
    call Spell.AddInit(function thistype.Init_obj_Buff)
endmethod