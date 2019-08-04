static constant integer MISSILE_GRAPHIC_SPELL_ID = 'ABuX'
    
    
static method Init_obj_missileGraphicSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\missileGraphicSpell.wc3spell")
    call InitAbility('ABuX')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BurningOil.page\\BurningOil.struct\\missileGraphicSpell.wc3spell")
    call t.Destroy()
endmethod