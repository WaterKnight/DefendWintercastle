
static method Init_obj_slots3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[3].wc3spell")
    call InitAbility('AHS3')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[3].wc3spell")
    call t.Destroy()
endmethod