static constant integer DUMMY_UNIT_ID = 'qKnO'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Knockout.page\\Knockout.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Knockout.page\\Knockout.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod