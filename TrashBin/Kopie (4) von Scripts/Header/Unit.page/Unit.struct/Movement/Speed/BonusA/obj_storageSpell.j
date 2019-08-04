static constant integer STORAGE_SPELL_ID = 'AmSx'
    
    
static method Init_obj_storageSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\storageSpell.wc3spell")
    call InitAbility('AmSx')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\storageSpell.wc3spell")
    call t.Destroy()
endmethod