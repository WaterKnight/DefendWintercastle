static string IMPACT_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real array IMPACT_DAMAGE_FACTOR
static integer array MAX_Z
static real MAX_ANGLE_OFFSET = 0.65 * Math.QUARTER_ANGLE
static string IMPACT_EFFECT_PATH = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"
static integer IMPACT_TOLERANCE = 10
static integer array MAX_LENGTH
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\Arrival\\Target\\this.wc3obj")
    set thistype.IMPACT_DAMAGE_FACTOR[1] = 1.5
    set thistype.IMPACT_DAMAGE_FACTOR[2] = 2.5
    set thistype.IMPACT_DAMAGE_FACTOR[3] = 3.5
    set thistype.MAX_Z[1] = 275
    set thistype.MAX_Z[2] = 275
    set thistype.MAX_Z[3] = 275
    set thistype.MAX_LENGTH[1] = 600
    set thistype.MAX_LENGTH[2] = 725
    set thistype.MAX_LENGTH[3] = 850
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\Arrival\\Target\\this.wc3obj")
    call t.Destroy()
endmethod