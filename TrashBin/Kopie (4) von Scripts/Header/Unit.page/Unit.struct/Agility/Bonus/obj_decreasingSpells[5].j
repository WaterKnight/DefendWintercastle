
static method Init_obj_decreasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\decreasingSpells[5].wc3spell")
    call InitAbility('AdG5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\decreasingSpells[5].wc3spell")
    call t.Destroy()
endmethod