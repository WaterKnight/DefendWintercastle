static constant integer HORSE_ID = 'qHoR'
    
    
static method Init_obj_horse takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\Target\\horse.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\HorseRide.page\\HorseRide.struct\\Target\\horse.wc3unit")
    call t.Destroy()
endmethod