static integer array SLOTS_ID
    
    
static method Init_obj_slots0 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[0].wc3spell")
    call InitAbility('AHS0')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Spell.page\\HeroSpell.struct\\slots[0].wc3spell")
    call t.Destroy()
endmethod