
static method Init_obj_increasingSpells9 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[9].wc3spell")
    call InitAbility('AiR9')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[9].wc3spell")
    call t.Destroy()
endmethod