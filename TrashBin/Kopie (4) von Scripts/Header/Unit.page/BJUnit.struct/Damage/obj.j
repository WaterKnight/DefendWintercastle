//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_this.j
static integer array PACKETS
static integer INCREASING_ITEMS_MAX = 7
static integer DECREASING_ITEMS_MAX = 7
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\this.wc3obj")
    set thistype.PACKETS[0] = 1
    set thistype.PACKETS[1] = 2
    set thistype.PACKETS[2] = 4
    set thistype.PACKETS[3] = 8
    set thistype.PACKETS[4] = 16
    set thistype.PACKETS[5] = 32
    set thistype.PACKETS[6] = 64
    set thistype.PACKETS[7] = 128
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[5].j

static method Init_obj_decreasingItemTypes5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[5].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[5].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[4].j
static integer array INCREASING_ITEM_TYPES_ID
    
    
static method Init_obj_increasingItemTypes4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[4].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[4].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[6].j

static method Init_obj_decreasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[6].wc3spell")
    call InitAbility('Add6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[7].j

static method Init_obj_increasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[7].wc3spell")
    call InitAbility('Aid7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[7].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[1].j

static method Init_obj_decreasingItemTypes1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[1].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[1].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[7].j

static method Init_obj_decreasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[7].wc3spell")
    call InitAbility('Add7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[7].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[4].j

static method Init_obj_increasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[4].wc3spell")
    call InitAbility('Aid4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[7].j

static method Init_obj_increasingItemTypes7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[7].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[7].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[6].j
static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[6].wc3spell")
    call InitAbility('Aid6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[5].j

static method Init_obj_increasingItemTypes5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[5].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[5].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[3].j

static method Init_obj_increasingItemTypes3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[3].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[3].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[1].j
static integer array DECREASING_SPELLS_ID
    
    
static method Init_obj_decreasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[1].wc3spell")
    call InitAbility('Add1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[3].j

static method Init_obj_increasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[3].wc3spell")
    call InitAbility('Aid3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[5].j

static method Init_obj_decreasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[5].wc3spell")
    call InitAbility('Add5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[3].j

static method Init_obj_decreasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[3].wc3spell")
    call InitAbility('Add3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[5].j

static method Init_obj_increasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[5].wc3spell")
    call InitAbility('Aid5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[2].j

static method Init_obj_increasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[2].wc3spell")
    call InitAbility('Aid2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[0].j

static method Init_obj_increasingItemTypes0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[0].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[0].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[0].j

static method Init_obj_decreasingItemTypes0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[0].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[0].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[0].j

static method Init_obj_increasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[0].wc3spell")
    call InitAbility('Aid0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[4].j

static method Init_obj_decreasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[4].wc3spell")
    call InitAbility('Add4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[2].j

static method Init_obj_decreasingItemTypes2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[2].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[2].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[2].j

static method Init_obj_decreasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[2].wc3spell")
    call InitAbility('Add2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[0].j

static method Init_obj_decreasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[0].wc3spell")
    call InitAbility('Add0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[1].j

static method Init_obj_increasingItemTypes1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[1].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[1].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[6].j

static method Init_obj_decreasingItemTypes6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[6].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[6].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[4].j

static method Init_obj_decreasingItemTypes4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[4].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[4].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[7].j

static method Init_obj_decreasingItemTypes7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[7].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[7].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[2].j

static method Init_obj_increasingItemTypes2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[2].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[2].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[3].j
static integer array DECREASING_ITEM_TYPES_ID
    
    
static method Init_obj_decreasingItemTypes3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[3].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingItemTypes[3].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_decreasingItemTypes[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[1].j

static method Init_obj_increasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[1].wc3spell")
    call InitAbility('Aid1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[6].j

static method Init_obj_increasingItemTypes6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[6].wc3item")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingItemTypes[6].wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Damage\obj_increasingItemTypes[6].j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes5)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes4)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells6)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells7)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes1)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells7)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells4)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes7)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells6)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes5)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes3)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells1)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells3)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells5)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells3)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells5)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells2)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes0)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes0)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells0)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells4)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes2)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells2)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells0)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes1)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes6)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes4)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes7)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes2)
    call ItemType.AddInit(function thistype.Init_obj_decreasingItemTypes3)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells1)
    call ItemType.AddInit(function thistype.Init_obj_increasingItemTypes6)
endmethod