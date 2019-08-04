
static method Init_obj_decreasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[7].wc3spell")
    call InitAbility('Add7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[7].wc3spell")
    call t.Destroy()
endmethod