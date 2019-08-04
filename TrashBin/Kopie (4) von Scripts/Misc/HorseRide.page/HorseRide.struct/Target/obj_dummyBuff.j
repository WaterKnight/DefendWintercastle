static Buff DUMMY_BUFF
    
static string START_EFFECT_PATH = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
static integer FADE_OUT = 2
static integer DISMOUNT_OFFSET = 200
static string HORSE_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string HORSE_EFFECT_PATH = "UI\\Feedback\\WaypointFlags\\WaypointFlag.mdl"
static string ENDING_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real DUMMY_UNIT_DURATION = 0.5
static string START_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string ENDING_EFFECT_PATH = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
static integer DUMMY_UNIT_OFFSET = -65
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\Target\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\Target\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod