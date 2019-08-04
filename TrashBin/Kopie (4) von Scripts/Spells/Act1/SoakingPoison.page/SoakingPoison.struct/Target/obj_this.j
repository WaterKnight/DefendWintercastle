static real INTERVAL = 0.5
static integer DURATION = 4
static integer DAMAGE_PER_SECOND = 5
static integer HERO_DURATION = 2
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\SoakingPoison.page\\SoakingPoison.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod