static constant integer WORLD_CASTER_ID = 'qWoC'
    
    
static method Init_obj_worldCaster takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\worldCaster.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\worldCaster.wc3unit")
    call t.Destroy()
endmethod