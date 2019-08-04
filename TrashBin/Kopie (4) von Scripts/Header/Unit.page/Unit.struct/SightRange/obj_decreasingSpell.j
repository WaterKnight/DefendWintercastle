static constant integer DECREASING_SPELL_ID = 'AdSR'
    
    
static method Init_obj_decreasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\decreasingSpell.wc3spell")
    call InitAbility('AdSR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\decreasingSpell.wc3spell")
    call t.Destroy()
endmethod