
static method Init_obj_increasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\increasingSpells[1].wc3spell")
    call InitAbility('AiG1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Intelligence\\Bonus\\increasingSpells[1].wc3spell")
    call t.Destroy()
endmethod