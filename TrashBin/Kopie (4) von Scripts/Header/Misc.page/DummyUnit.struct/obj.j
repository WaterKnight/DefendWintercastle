//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Misc.page\DummyUnit.struct\obj_worldCaster.j
static constant integer WORLD_CASTER_ID = 'qWoC'
    
    
static method Init_obj_worldCaster takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\worldCaster.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\worldCaster.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Misc.page\DummyUnit.struct\obj_worldCaster.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Header\Misc.page\DummyUnit.struct\obj_locustSpell.j
static constant integer LOCUST_SPELL_ID = 'aLoc'
    
    
static method Init_obj_locustSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\locustSpell.wc3spell")
    call InitAbility('aLoc')
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Header\\Misc.page\\DummyUnit.struct\\locustSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Header\Misc.page\DummyUnit.struct\obj_locustSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_worldCaster)
    call Spell.AddInit(function thistype.Init_obj_locustSpell)
endmethod