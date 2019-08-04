//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar\obj_FrozenStar.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar\obj_Target.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar\obj_Explosion.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_FrozenStar)
    call Spell.AddInit(function thistype.Init_obj_Target)
    call Spell.AddInit(function thistype.Init_obj_Explosion)
endmethod