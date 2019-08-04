static constant integer DISABLE_SPELL_ID = 'Abun'
    
    
static method Init_obj_disableSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\disableSpell.wc3spell")
    call InitAbility('Abun')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\disableSpell.wc3spell")
    call t.Destroy()
endmethod