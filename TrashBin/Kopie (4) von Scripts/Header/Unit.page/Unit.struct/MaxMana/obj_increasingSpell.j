static constant integer INCREASING_SPELL_ID = 'AiMn'
    
    
static method Init_obj_increasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxMana\\increasingSpell.wc3spell")
    call InitAbility('AiMn')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxMana\\increasingSpell.wc3spell")
    call t.Destroy()
endmethod