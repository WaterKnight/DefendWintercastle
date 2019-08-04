static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[1].wc3spell")
    call InitAbility('AiR1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Attack\\Speed\\BonusA\\increasingSpells[1].wc3spell")
    call t.Destroy()
endmethod