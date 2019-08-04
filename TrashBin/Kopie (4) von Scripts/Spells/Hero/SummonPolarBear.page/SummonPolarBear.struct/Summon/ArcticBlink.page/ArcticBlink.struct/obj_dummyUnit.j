static constant integer DUMMY_UNIT_ID = 'qArB'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod