static constant integer DUMMY_SPELL_ID = 'ARev'
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Revival\\dummySpell.wc3spell")
    call InitAbility('ARev')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Revival\\dummySpell.wc3spell")
    call t.Destroy()
endmethod