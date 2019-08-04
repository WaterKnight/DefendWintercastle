//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\obj_heroInventorySpell.j
static constant integer HERO_INVENTORY_SPELL_ID = 'AInv'
    
    
static method Init_obj_heroInventorySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\heroInventorySpell.wc3spell")
    call InitAbility('AInv')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Unit.page\\Unit.struct\\heroInventorySpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.struct\obj_heroInventorySpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_heroInventorySpell)
endmethod