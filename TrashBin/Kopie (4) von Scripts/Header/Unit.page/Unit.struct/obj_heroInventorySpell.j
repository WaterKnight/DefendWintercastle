static constant integer HERO_INVENTORY_SPELL_ID = 'AInv'
    
    
static method Init_obj_heroInventorySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\heroInventorySpell.wc3spell")
    call InitAbility('AInv')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\heroInventorySpell.wc3spell")
    call t.Destroy()
endmethod