//open object D:\Warcraft III\Maps\DWC\Scripts\obj_empty.j
static DestructableType EMPTY
    
    
static method Init_obj_empty takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\empty.wc3dest")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\empty.wc3dest")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\obj_empty.j

//open object D:\Warcraft III\Maps\DWC\Scripts\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qWoC'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call DestructableType.AddInit(function thistype.Init_obj_empty)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod