static constant integer DUMMY_SPELL_ID = 'AmSp'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\dummySpell.wc3spell")
    call InitAbility('AmSp')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Movement\\Speed\\BonusA\\dummySpell.wc3spell")
    call t.Destroy()
endmethod