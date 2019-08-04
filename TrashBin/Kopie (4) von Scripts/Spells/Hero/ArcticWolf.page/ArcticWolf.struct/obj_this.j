static integer array SUMMON_DURATION
static integer SPEED = 400
static integer START_OFFSET = 90
static integer HEIGHT = 50
static string DUMMY_UNIT_EFFECT_PATH = "Spells\\ArcticWolf\\IceVortex.mdl"
static real DUMMY_UNIT_FADE_OUT = 0.5
static integer array STUN_DURATION
static string DUMMY_UNIT_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\this.wc3obj")
    set thistype.SUMMON_DURATION[1] = 60
    set thistype.SUMMON_DURATION[2] = 60
    set thistype.SUMMON_DURATION[3] = 60
    set thistype.SUMMON_DURATION[4] = 60
    set thistype.SUMMON_DURATION[5] = 60
    set thistype.STUN_DURATION[1] = 3
    set thistype.STUN_DURATION[2] = 4
    set thistype.STUN_DURATION[3] = 5
    set thistype.STUN_DURATION[4] = 5
    set thistype.STUN_DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ArcticWolf.page\\ArcticWolf.struct\\this.wc3obj")
    call t.Destroy()
endmethod