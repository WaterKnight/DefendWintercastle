//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[4].j

static method Init_obj_decreasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[4].wc3spell")
    call InitAbility('AdD4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[6].j

static method Init_obj_increasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[6].wc3spell")
    call InitAbility('AiD6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[2].j

static method Init_obj_decreasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[2].wc3spell")
    call InitAbility('AdD2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[0].j

static method Init_obj_increasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[0].wc3spell")
    call InitAbility('AiD0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[5].j

static method Init_obj_increasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[5].wc3spell")
    call InitAbility('AiD5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_this.j
static integer DECREASING_SPELLS_MAX = 6
static integer array PACKETS
static integer INCREASING_SPELLS_MAX = 6
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\this.wc3obj")
    set thistype.PACKETS[0] = 1
    set thistype.PACKETS[1] = 2
    set thistype.PACKETS[2] = 4
    set thistype.PACKETS[3] = 8
    set thistype.PACKETS[4] = 16
    set thistype.PACKETS[5] = 32
    set thistype.PACKETS[6] = 64
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[0].j
static integer array DECREASING_SPELLS_ID
    
    
static method Init_obj_decreasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[0].wc3spell")
    call InitAbility('AdD0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[3].j

static method Init_obj_decreasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[3].wc3spell")
    call InitAbility('AdD3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[6].j

static method Init_obj_decreasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[6].wc3spell")
    call InitAbility('AdD6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[5].j

static method Init_obj_decreasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[5].wc3spell")
    call InitAbility('AdD5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[1].j

static method Init_obj_decreasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[1].wc3spell")
    call InitAbility('AdD1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_decreasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[4].j

static method Init_obj_increasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[4].wc3spell")
    call InitAbility('AiD4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[1].j

static method Init_obj_increasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[1].wc3spell")
    call InitAbility('AiD1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[2].j

static method Init_obj_increasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[2].wc3spell")
    call InitAbility('AiD2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[3].j
static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[3].wc3spell")
    call InitAbility('AiD3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\Bonus\obj_increasingSpells[3].j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells4)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells6)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells2)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells0)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells5)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells0)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells3)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells6)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells5)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells1)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells4)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells1)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells2)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells3)
endmethod