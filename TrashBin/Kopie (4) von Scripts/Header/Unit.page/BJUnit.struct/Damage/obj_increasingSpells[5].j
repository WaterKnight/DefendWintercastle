
static method Init_obj_increasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[5].wc3spell")
    call InitAbility('Aid5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\increasingSpells[5].wc3spell")
    call t.Destroy()
endmethod