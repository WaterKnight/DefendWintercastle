
static method Init_obj_decreasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[2].wc3spell")
    call InitAbility('Add2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\decreasingSpells[2].wc3spell")
    call t.Destroy()
endmethod