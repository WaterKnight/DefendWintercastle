static constant integer LOCUST_SPELL_ID = 'aLoc'
    
    
static method Init_obj_locustSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\locustSpell.wc3spell")
    call InitAbility('aLoc')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\locustSpell.wc3spell")
    call t.Destroy()
endmethod