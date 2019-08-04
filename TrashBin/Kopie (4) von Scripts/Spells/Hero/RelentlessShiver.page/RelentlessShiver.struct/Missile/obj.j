//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Missile\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qReS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Missile\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Missile\obj_this.j
static integer array DAMAGE
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\this.wc3obj")
    set thistype.DAMAGE[1] = 10
    set thistype.DAMAGE[2] = 20
    set thistype.DAMAGE[3] = 30
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\Missile\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Missile\obj_this.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
endmethod