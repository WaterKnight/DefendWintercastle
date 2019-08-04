static integer array INCREASING_SPELLS_ID
    
    
static method Init_obj_increasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[3].wc3spell")
    call InitAbility('AiD3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Damage\\Bonus\\increasingSpells[3].wc3spell")
    call t.Destroy()
endmethod