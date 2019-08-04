//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_increasingSpell.j
static constant integer INCREASING_SPELL_ID = 'AiSR'
    
    
static method Init_obj_increasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\increasingSpell.wc3spell")
    call InitAbility('AiSR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\increasingSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_increasingSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_this.j
static integer DECREASING_SPELLS_MAX = 12
static integer array PACKETS
static integer INCREASING_SPELLS_MAX = 12
    
static method Init_obj_this takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\this.wc3obj")
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
    set thistype.PACKETS[10] = 1024
    set thistype.PACKETS[11] = 2048
    set thistype.PACKETS[12] = 4096
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\this.wc3obj")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_this.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_decreasingSpell.j
static constant integer DECREASING_SPELL_ID = 'AdSR'
    
    
static method Init_obj_decreasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\decreasingSpell.wc3spell")
    call InitAbility('AdSR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\decreasingSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\SightRange\obj_decreasingSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_increasingSpell)
    call Trigger.AddObjectInitNormal(function thistype.Init_obj_this)
    call Spell.AddInit(function thistype.Init_obj_decreasingSpell)
endmethod