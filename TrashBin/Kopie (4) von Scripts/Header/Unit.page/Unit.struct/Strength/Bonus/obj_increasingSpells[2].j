static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[2].wc3spell")
    call InitAbility('AiG2')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[2].wc3spell")
    call t.Destroy()
endmethod