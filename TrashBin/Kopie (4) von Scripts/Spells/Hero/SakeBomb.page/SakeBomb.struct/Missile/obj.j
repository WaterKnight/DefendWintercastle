//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\Missile\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSBM'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\Missile\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\Missile\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\Missile\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod