//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\ChillyBreath\obj_Buff.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\ChillyBreath\obj_ChillyBreath.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Buff)
    call Spell.AddInit(function thistype.Init_obj_ChillyBreath)
endmethod