static constant integer Z_ENABLER_SPELL_ID = 'aFly'
    
    
static method Init_obj_zEnablerSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerSpell.wc3spell")
    call InitAbility('aFly')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\zEnablerSpell.wc3spell")
    call t.Destroy()
endmethod