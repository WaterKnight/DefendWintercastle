static string array SUMMON_EFFECT_ATTACH_POINT
static string array SUMMON_EFFECT_PATH
static integer array FIELD
static integer array DURATION
static integer array SUMMON_DURATION
static string array SUMMON_DEATH_EFFECT_PATH
    
static method Init_obj_Buff takes nothing returns nothing
    set thistype.SUMMON_EFFECT_ATTACH_POINT[1] = AttachPoint.ORIGIN
    set thistype.SUMMON_EFFECT_PATH[1] = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
    set thistype.FIELD[1] = 1
    set thistype.DURATION[1] = 4
    set thistype.SUMMON_DURATION[1] = 30
    set thistype.SUMMON_DEATH_EFFECT_PATH[1] = "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[2] = AttachPoint.ORIGIN
    set thistype.SUMMON_EFFECT_PATH[2] = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
    set thistype.FIELD[2] = 2
    set thistype.DURATION[2] = 5
    set thistype.SUMMON_DURATION[2] = 30
    set thistype.SUMMON_DEATH_EFFECT_PATH[2] = "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl"
    set thistype.SUMMON_EFFECT_ATTACH_POINT[3] = AttachPoint.ORIGIN
    set thistype.SUMMON_EFFECT_PATH[3] = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
    set thistype.FIELD[3] = 3
    set thistype.DURATION[3] = 6
    set thistype.SUMMON_DURATION[3] = 30
    set thistype.SUMMON_DEATH_EFFECT_PATH[3] = "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl"
endmethod