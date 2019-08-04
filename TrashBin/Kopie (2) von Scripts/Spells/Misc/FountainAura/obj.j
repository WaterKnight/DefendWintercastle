//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainAura\obj_FountainAura.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainAura\obj_Target.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_FountainAura)
    call Spell.AddInit(function thistype.Init_obj_Target)
endmethod