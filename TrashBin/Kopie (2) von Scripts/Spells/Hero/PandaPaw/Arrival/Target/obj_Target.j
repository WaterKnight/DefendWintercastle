static integer array KNOCK_BACK_LENGTH
static string array IMPACT_EFFECT_ATTACH_POINT
static integer array KNOCKBACK_HEIGHT
static real array IMPACT_DAMAGE_FACTOR
static string array MAX_ANGLE_OFFSET
static string array IMPACT_EFFECT_PATH
static integer array IMPACT_TOLERANCE
static integer array FIELD
    
static method Init_obj_Target takes nothing returns nothing
    set thistype.KNOCK_BACK_LENGTH[1] = 600
    set thistype.IMPACT_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.KNOCKBACK_HEIGHT[1] = 275
    set thistype.IMPACT_DAMAGE_FACTOR[1] = 1.5
    set thistype.MAX_ANGLE_OFFSET[1] = "0.65 * Math.QUARTER_ANGLE"
    set thistype.IMPACT_EFFECT_PATH[1] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    set thistype.IMPACT_TOLERANCE[1] = 10
    set thistype.FIELD[1] = 1
    set thistype.KNOCK_BACK_LENGTH[2] = 725
    set thistype.IMPACT_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.KNOCKBACK_HEIGHT[2] = 275
    set thistype.IMPACT_DAMAGE_FACTOR[2] = 2.5
    set thistype.MAX_ANGLE_OFFSET[2] = "0.65 * Math.QUARTER_ANGLE"
    set thistype.IMPACT_EFFECT_PATH[2] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    set thistype.IMPACT_TOLERANCE[2] = 10
    set thistype.FIELD[2] = 2
    set thistype.KNOCK_BACK_LENGTH[3] = 850
    set thistype.IMPACT_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.KNOCKBACK_HEIGHT[3] = 275
    set thistype.IMPACT_DAMAGE_FACTOR[3] = 3.5
    set thistype.MAX_ANGLE_OFFSET[3] = "0.65 * Math.QUARTER_ANGLE"
    set thistype.IMPACT_EFFECT_PATH[3] = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
    set thistype.IMPACT_TOLERANCE[3] = 10
    set thistype.FIELD[3] = 3
endmethod