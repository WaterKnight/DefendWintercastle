static constant integer INCREASING_SPELL_ID = 'AiSR'
    
    
static method Init_obj_increasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\increasingSpell.wc3spell")
    call InitAbility('AiSR')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\SightRange\\increasingSpell.wc3spell")
    call t.Destroy()
endmethod