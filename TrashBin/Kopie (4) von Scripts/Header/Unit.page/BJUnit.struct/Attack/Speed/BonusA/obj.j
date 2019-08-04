//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_this.j
static integer DECREASING_SPELLS_MAX = 9
static integer array PACKETS
static integer INCREASING_SPELLS_MAX = 9
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\this.wc3obj")
    set thistype.PACKETS[0] = 1
    set thistype.PACKETS[1] = 2
    set thistype.PACKETS[2] = 4
    set thistype.PACKETS[3] = 8
    set thistype.PACKETS[4] = 16
    set thistype.PACKETS[5] = 32
    set thistype.PACKETS[6] = 64
    set thistype.PACKETS[7] = 128
    set thistype.PACKETS[8] = 256
    set thistype.PACKETS[9] = 512
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[6].j

static method Init_obj_decreasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[6].wc3spell")
    call InitAbility('AdR6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[0].j
static integer array DECREASING_SPELLS_ID
    
    
static method Init_obj_decreasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[0].wc3spell")
    call InitAbility('AdR0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[2].j

static method Init_obj_decreasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[2].wc3spell")
    call InitAbility('AdR2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[8].j

static method Init_obj_decreasingSpells8 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[8].wc3spell")
    call InitAbility('AdR8')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[8].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[8].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[6].j

static method Init_obj_increasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[6].wc3spell")
    call InitAbility('AiR6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[6].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[6].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[2].j

static method Init_obj_increasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[2].wc3spell")
    call InitAbility('AiR2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[2].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[4].j

static method Init_obj_increasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[4].wc3spell")
    call InitAbility('AiR4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[5].j

static method Init_obj_increasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[5].wc3spell")
    call InitAbility('AiR5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[0].j

static method Init_obj_increasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[0].wc3spell")
    call InitAbility('AiR0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[0].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[0].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[4].j

static method Init_obj_decreasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[4].wc3spell")
    call InitAbility('AdR4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[4].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[4].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[7].j

static method Init_obj_increasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[7].wc3spell")
    call InitAbility('AiR7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[7].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[7].j

static method Init_obj_decreasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[7].wc3spell")
    call InitAbility('AdR7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[7].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[7].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[3].j

static method Init_obj_increasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[3].wc3spell")
    call InitAbility('AiR3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[3].j

static method Init_obj_decreasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[3].wc3spell")
    call InitAbility('AdR3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[3].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[5].j

static method Init_obj_decreasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[5].wc3spell")
    call InitAbility('AdR5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[5].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[1].j

static method Init_obj_decreasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[1].wc3spell")
    call InitAbility('AdR1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[9].j

static method Init_obj_increasingSpells9 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[9].wc3spell")
    call InitAbility('AiR9')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[9].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[9].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[1].j
static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[1].wc3spell")
    call InitAbility('AiR1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[1].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[8].j

static method Init_obj_increasingSpells8 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[8].wc3spell")
    call InitAbility('AiR8')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[8].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_increasingSpells[8].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[9].j

static method Init_obj_decreasingSpells9 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[9].wc3spell")
    call InitAbility('AdR9')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[9].wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\BJUnit.struct\Attack\Speed\BonusA\obj_decreasingSpells[9].j


private static method onInit takes nothing returns nothing
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells6)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells0)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells2)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells8)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells6)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells2)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells4)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells5)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells0)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells4)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells7)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells7)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells3)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells3)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells5)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells1)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells9)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells1)
    call Spell.AddInit(function thistype.Init_obj_increasingSpells8)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpells9)
endmethod