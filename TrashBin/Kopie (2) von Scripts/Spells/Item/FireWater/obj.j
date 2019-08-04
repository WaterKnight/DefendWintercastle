//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\FireWater\obj_FireWater.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\FireWater\obj_Buff.j"

private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_FireWater)
    call Spell.AddInit(function thistype.Init_obj_Buff)
endmethod