//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\VividMeteor\obj_Effects.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\VividMeteor\obj_VividMeteor.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_Effects)
    call Spell.AddInit(function thistype.Init_obj_VividMeteor)
endmethod