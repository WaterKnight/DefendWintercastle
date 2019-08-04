static constant integer INCREASING_SPELL_ID = 'AiLf'
    
    
static method Init_obj_increasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxLife\\increasingSpell.wc3spell")
    call InitAbility('AiLf')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxLife\\increasingSpell.wc3spell")
    call t.Destroy()
endmethod