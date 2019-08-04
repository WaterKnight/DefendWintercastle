static constant integer LOAD_IN_SPELL_ID = 'Aloa'
    
    
static method Init_obj_loadInSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\loadInSpell.wc3spell")
    call InitAbility('Aloa')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\loadInSpell.wc3spell")
    call t.Destroy()
endmethod