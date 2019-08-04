static real INTERVAL = 0.5
static integer DURATION = 3
static integer DAMAGE_PER_SECOND = 20
static integer HERO_DURATION = 1
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\EnvenomedSpears.page\\EnvenomedSpears.struct\\Target\\this.wc3obj")
    call t.Destroy()
endmethod