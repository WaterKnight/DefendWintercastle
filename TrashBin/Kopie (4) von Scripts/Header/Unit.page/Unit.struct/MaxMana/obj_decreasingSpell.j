static constant integer DECREASING_SPELL_ID = 'AdMn'
    
    
static method Init_obj_decreasingSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxMana\\decreasingSpell.wc3spell")
    call InitAbility('AdMn')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\MaxMana\\decreasingSpell.wc3spell")
    call t.Destroy()
endmethod