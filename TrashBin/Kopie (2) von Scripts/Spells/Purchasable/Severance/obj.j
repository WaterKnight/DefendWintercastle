//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance\obj_Severance.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance\obj_Buff.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Severance)
    call Spell.AddInit(function thistype.Init_obj_Buff)
endmethod