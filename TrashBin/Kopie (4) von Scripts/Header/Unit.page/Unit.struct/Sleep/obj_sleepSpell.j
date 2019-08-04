static constant integer SLEEP_SPELL_ID = 'ACsl'
    
    
static method Init_obj_sleepSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Sleep\\sleepSpell.wc3spell")
    call InitAbility('ACsl')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Sleep\\sleepSpell.wc3spell")
    call t.Destroy()
endmethod