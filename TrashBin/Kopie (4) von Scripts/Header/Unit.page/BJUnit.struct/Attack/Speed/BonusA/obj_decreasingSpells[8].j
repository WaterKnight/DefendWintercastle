
static method Init_obj_decreasingSpells8 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[8].wc3spell")
    call InitAbility('AdR8')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\decreasingSpells[8].wc3spell")
    call t.Destroy()
endmethod