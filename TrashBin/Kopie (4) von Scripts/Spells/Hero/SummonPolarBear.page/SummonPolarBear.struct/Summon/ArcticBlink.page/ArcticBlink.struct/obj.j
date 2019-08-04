//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\ArcticBlink.page\ArcticBlink.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qArB'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\ArcticBlink.page\ArcticBlink.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\ArcticBlink.page\ArcticBlink.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer STUN_DURATION = 2
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AArB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Arctic Blink")
    call thistype.THIS_SPELL.SetOrder(OrderId("thunderbolt"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 9)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 800)
    call thistype.THIS_SPELL.SetCooldown(2, 9)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 800)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 800)
    call thistype.THIS_SPELL.SetCooldown(4, 9)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 800)
    call thistype.THIS_SPELL.SetCooldown(5, 9)
    call thistype.THIS_SPELL.SetManaCost(5, 80)
    call thistype.THIS_SPELL.SetRange(5, 800)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBearBlink.blp")
    
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 50
    set thistype.DAMAGE[4] = 60
    set thistype.DAMAGE[5] = 70
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SummonPolarBear.page\\SummonPolarBear.struct\\Summon\\ArcticBlink.page\\ArcticBlink.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon\ArcticBlink.page\ArcticBlink.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod