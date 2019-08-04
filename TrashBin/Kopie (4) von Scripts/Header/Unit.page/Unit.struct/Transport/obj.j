//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_loadInSpell.j
static constant integer LOAD_IN_SPELL_ID = 'Aloa'
    
    
static method Init_obj_loadInSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\loadInSpell.wc3spell")
    call InitAbility('Aloa')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\loadInSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_loadInSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_cargoSpell.j
static constant integer CARGO_SPELL_ID = 'ATra'
    
    
static method Init_obj_cargoSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\cargoSpell.wc3spell")
    call InitAbility('ATra')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\cargoSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_cargoSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qTra'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Transport\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_loadInSpell)
    call Spell.AddInit(function thistype.Init_obj_cargoSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod