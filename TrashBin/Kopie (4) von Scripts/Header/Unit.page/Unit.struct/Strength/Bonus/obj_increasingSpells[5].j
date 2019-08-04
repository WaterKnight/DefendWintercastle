
static method Init_obj_increasingSpells5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[5].wc3spell")
    call InitAbility('AiG5')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Strength\\Bonus\\increasingSpells[5].wc3spell")
    call t.Destroy()
endmethod