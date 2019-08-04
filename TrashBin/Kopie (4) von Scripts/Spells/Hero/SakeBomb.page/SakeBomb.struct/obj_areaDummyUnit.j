static constant integer AREA_DUMMY_UNIT_ID = 'qSBA'
    
    
static method Init_obj_areaDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\areaDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\areaDummyUnit.wc3unit")
    call t.Destroy()
endmethod