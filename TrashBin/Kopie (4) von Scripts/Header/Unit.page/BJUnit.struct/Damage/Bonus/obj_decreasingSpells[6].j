
static method Init_obj_decreasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[6].wc3spell")
    call InitAbility('AdD6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\decreasingSpells[6].wc3spell")
    call t.Destroy()
endmethod