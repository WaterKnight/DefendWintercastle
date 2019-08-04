//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura\obj_RevealAura.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura\obj_Target.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_RevealAura)
    call Spell.AddInit(function thistype.Init_obj_Target)
endmethod