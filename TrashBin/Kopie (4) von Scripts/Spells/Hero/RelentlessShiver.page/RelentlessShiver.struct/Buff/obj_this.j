static integer array SUMMON_DURATION
static string SUMMON_EFFECT_PATH = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
static integer array DURATION
static string SUMMON_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string SUMMON_DEATH_EFFECT_PATH = "Objects\\Spawnmodels\\Undead\\UndeadLargeDeathExplode\\UndeadLargeDeathExplode.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\this.wc3obj")
    set thistype.SUMMON_DURATION[1] = 30
    set thistype.SUMMON_DURATION[2] = 30
    set thistype.SUMMON_DURATION[3] = 30
    set thistype.DURATION[1] = 4
    set thistype.DURATION[2] = 5
    set thistype.DURATION[3] = 6
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod