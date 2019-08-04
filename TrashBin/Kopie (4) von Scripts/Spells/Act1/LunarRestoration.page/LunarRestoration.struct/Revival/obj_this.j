static real MANA_FACTOR = 0.3
static real DURATION = 4.5
static real LIFE_FACTOR = 0.3
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LunarRestoration.page\\LunarRestoration.struct\\Revival\\this.wc3obj")
    call t.Destroy()
endmethod