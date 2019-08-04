
static method Init_obj_decreasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\decreasingSpells[0].wc3spell")
    call InitAbility('AdG0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\decreasingSpells[0].wc3spell")
    call t.Destroy()
endmethod