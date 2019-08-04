//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.struct\Wave\obj_this.j
static integer OFFSET = 125
static integer AREA_RANGE = 125
static integer SPEED = 650
static integer DAMAGE = 40
static integer MAX_LENGTH = 600
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\this.wc3obj")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.struct\Wave\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.struct\Wave\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qClv'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Cleavage.page\\Cleavage.struct\\Wave\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.struct\Wave\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod