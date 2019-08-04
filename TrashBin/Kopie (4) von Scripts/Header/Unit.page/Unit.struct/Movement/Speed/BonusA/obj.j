//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Movement\Speed\BonusA\obj_storageSpell.j
static constant integer STORAGE_SPELL_ID = 'AmSx'
    
    
static method Init_obj_storageSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\storageSpell.wc3spell")
    call InitAbility('AmSx')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\storageSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Movement\Speed\BonusA\obj_storageSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Movement\Speed\BonusA\obj_dummySpell.j
static constant integer DUMMY_SPELL_ID = 'AmSp'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\dummySpell.wc3spell")
    call InitAbility('AmSp')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\dummySpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\Movement\Speed\BonusA\obj_dummySpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_storageSpell)
    call Spell.AddInit(function thistype.Init_obj_dummySpell)
endmethod