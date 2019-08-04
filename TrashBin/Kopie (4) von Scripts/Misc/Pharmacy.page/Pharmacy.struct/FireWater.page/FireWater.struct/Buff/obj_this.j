static real INTERVAL = 0.35
static integer DURATION = 15
static integer DAMAGE_PER_SECOND = 30
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\Pharmacy.page\\Pharmacy.struct\\FireWater.page\\FireWater.struct\\Buff\\this.wc3obj")
    call t.Destroy()
endmethod