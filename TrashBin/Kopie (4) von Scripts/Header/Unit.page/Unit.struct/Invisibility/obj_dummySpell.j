static constant integer DUMMY_SPELL_ID = 'Apiv'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Invisibility\\dummySpell.wc3spell")
    call InitAbility('Apiv')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Invisibility\\dummySpell.wc3spell")
    call t.Destroy()
endmethod