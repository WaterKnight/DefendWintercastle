
static method Init_obj_increasingSpells6 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\increasingSpells[6].wc3spell")
    call InitAbility('Aia6')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\increasingSpells[6].wc3spell")
    call t.Destroy()
endmethod