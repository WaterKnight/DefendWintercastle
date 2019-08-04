
static method Init_obj_decreasingSpells1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\decreasingSpells[1].wc3spell")
    call InitAbility('Ada1')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\BJUnit.struct\\Armor\\Bonus\\decreasingSpells[1].wc3spell")
    call t.Destroy()
endmethod