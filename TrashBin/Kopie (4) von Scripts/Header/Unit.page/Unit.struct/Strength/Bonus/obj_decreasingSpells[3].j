
static method Init_obj_decreasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\decreasingSpells[3].wc3spell")
    call InitAbility('AdG3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\decreasingSpells[3].wc3spell")
    call t.Destroy()
endmethod