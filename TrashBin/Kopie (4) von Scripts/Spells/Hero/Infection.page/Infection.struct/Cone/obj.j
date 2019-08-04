//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Cone\obj_this.j
static integer END_WIDTH = 300
static integer SPEED = 650
static integer START_WIDTH = 0
static integer array DAMAGE
static integer MAX_LENGTH = 500
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\this.wc3obj")
    set thistype.DAMAGE[1] = 10
    set thistype.DAMAGE[2] = 15
    set thistype.DAMAGE[3] = 25
    set thistype.DAMAGE[4] = 35
    set thistype.DAMAGE[5] = 45
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Cone\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Cone\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qIfc'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Infection.page\\Infection.struct\\Cone\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Cone\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod