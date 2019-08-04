
static method Init_obj_increasingSpells4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\increasingSpells[4].wc3spell")
    call InitAbility('AiG4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\increasingSpells[4].wc3spell")
    call t.Destroy()
endmethod