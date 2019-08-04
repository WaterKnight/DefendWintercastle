
static method Init_obj_increasingSpells7 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[7].wc3spell")
    call InitAbility('AiR7')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[7].wc3spell")
    call t.Destroy()
endmethod