//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer DURATION = 3
static integer DAMAGE = 40
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABoS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ITEM)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Boomerang Stone")
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 650)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_thisItem.j
static ItemType THIS_ITEM
    
    
static method Init_obj_thisItem takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\thisItem.wc3item")
    set thistype.THIS_ITEM = ItemType.CreateFromSelf('IBoS')
    call thistype.THIS_ITEM.Abilities.Add(BoomerangStone(NULL).THIS_SPELL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\thisItem.wc3item")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_thisItem.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qBoS'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Misc\\GarbageCollector.page\\GarbageCollector.struct\\BoomerangStone.page\\BoomerangStone.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Misc\GarbageCollector.page\GarbageCollector.struct\BoomerangStone.page\BoomerangStone.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call ItemType.AddInit(function thistype.Init_obj_thisItem)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod