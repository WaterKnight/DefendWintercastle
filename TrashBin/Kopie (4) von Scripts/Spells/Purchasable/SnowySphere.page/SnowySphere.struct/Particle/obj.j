//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\Particle\obj_this.j
static integer array SPEED
static integer array DAMAGE
static integer array AREA_RANGE
static integer array MAX_LENGTH
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\Particle\\this.wc3obj")
    set thistype.SPEED[1] = 700
    set thistype.SPEED[2] = 700
    set thistype.SPEED[3] = 700
    set thistype.SPEED[4] = 700
    set thistype.SPEED[5] = 700
    set thistype.DAMAGE[1] = 7
    set thistype.DAMAGE[2] = 13
    set thistype.DAMAGE[3] = 21
    set thistype.DAMAGE[4] = 31
    set thistype.DAMAGE[5] = 43
    set thistype.AREA_RANGE[1] = 50
    set thistype.AREA_RANGE[2] = 50
    set thistype.AREA_RANGE[3] = 50
    set thistype.AREA_RANGE[4] = 50
    set thistype.AREA_RANGE[5] = 50
    set thistype.MAX_LENGTH[1] = 400
    set thistype.MAX_LENGTH[2] = 500
    set thistype.MAX_LENGTH[3] = 600
    set thistype.MAX_LENGTH[4] = 700
    set thistype.MAX_LENGTH[5] = 800
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\Particle\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\Particle\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\Particle\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSnP'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\Particle\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\SnowySphere.page\\SnowySphere.struct\\Particle\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.struct\Particle\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod