
static method Init_obj_increasingSpells3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\increasingSpells[3].wc3spell")
    call InitAbility('AiG3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Agility\\Bonus\\increasingSpells[3].wc3spell")
    call t.Destroy()
endmethod