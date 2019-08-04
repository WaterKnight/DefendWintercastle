//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard\obj_Blizzard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard\obj_Wave.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Blizzard)
    call Spell.AddInit(function thistype.Init_obj_Wave)
endmethod