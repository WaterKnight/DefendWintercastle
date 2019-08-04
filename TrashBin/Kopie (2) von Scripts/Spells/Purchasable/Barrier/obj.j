//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier\obj_Knockback.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier\obj_Barrier.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Knockback)
    call Spell.AddInit(function thistype.Init_obj_Barrier)
endmethod