static constant integer ICON_SPELL_ID = 'ADAI'
    
    
static method Init_obj_iconSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\iconSpell.wc3spell")
    call InitAbility('ADAI')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Attack\\iconSpell.wc3spell")
    call t.Destroy()
endmethod