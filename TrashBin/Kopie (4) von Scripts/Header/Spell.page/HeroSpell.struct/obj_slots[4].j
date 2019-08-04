
static method Init_obj_slots4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[4].wc3spell")
    call InitAbility('AHS4')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[4].wc3spell")
    call t.Destroy()
endmethod