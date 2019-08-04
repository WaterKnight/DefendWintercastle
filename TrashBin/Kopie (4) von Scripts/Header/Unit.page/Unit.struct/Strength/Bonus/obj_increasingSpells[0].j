
static method Init_obj_increasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[0].wc3spell")
    call InitAbility('AiG0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[0].wc3spell")
    call t.Destroy()
endmethod