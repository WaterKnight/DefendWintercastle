
static method Init_obj_increasingSpells0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\increasingSpells[0].wc3spell")
    call InitAbility('Aia0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\increasingSpells[0].wc3spell")
    call t.Destroy()
endmethod