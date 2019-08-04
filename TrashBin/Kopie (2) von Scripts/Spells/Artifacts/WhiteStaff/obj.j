//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff\obj_WhiteStaff.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff\obj_Kopie von WhiteStaff.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_WhiteStaff)
    call Spell.AddInit(function thistype.Init_obj_Kopie von WhiteStaff)
endmethod