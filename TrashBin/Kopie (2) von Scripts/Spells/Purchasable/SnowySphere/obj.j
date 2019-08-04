//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere\obj_SnowySphere.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere\obj_Particle.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_SnowySphere)
    call Spell.AddInit(function thistype.Init_obj_Particle)
endmethod