static real array DAMAGE_RELATIVE_INCREMENT
static integer array FIELD
static string array TARGET_EFFECT_PATH
static string array TARGET_EFFECT_ATTACH_POINT
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.DAMAGE_RELATIVE_INCREMENT[1] = 0.2
    set thistype.FIELD[1] = 1
    set thistype.TARGET_EFFECT_PATH[1] = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
    set thistype.TARGET_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
endmethod