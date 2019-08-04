static integer array DECREASING_SPELLS_ID
    
    
static method Init_obj_decreasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\decreasingSpells[4].wc3spell")
    call InitAbility('AdG4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\decreasingSpells[4].wc3spell")
    call t.Destroy()
endmethod