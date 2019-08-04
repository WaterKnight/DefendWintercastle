static constant integer CARGO_SPELL_ID = 'ATra'
    
    
static method Init_obj_cargoSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\cargoSpell.wc3spell")
    call InitAbility('ATra')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\Transport\\cargoSpell.wc3spell")
    call t.Destroy()
endmethod