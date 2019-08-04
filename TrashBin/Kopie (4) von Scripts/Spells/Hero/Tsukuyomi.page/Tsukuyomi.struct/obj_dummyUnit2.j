static constant integer DUMMY_UNIT2_ID = 'qTs2'
    
    
static method Init_obj_dummyUnit2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit2.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit2.wc3unit")
    call t.Destroy()
endmethod