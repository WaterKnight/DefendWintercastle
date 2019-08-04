//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\Severance.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array TARGETS_AMOUNT
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASev')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Severance")
    call thistype.THIS_SPELL.SetOrder(OrderId("howlofterror"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 525)
    call thistype.THIS_SPELL.SetAreaRange(2, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 12)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 525)
    call thistype.THIS_SPELL.SetAreaRange(3, 500)
    call thistype.THIS_SPELL.SetCooldown(3, 12)
    call thistype.THIS_SPELL.SetManaCost(3, 65)
    call thistype.THIS_SPELL.SetRange(3, 525)
    call thistype.THIS_SPELL.SetAreaRange(4, 500)
    call thistype.THIS_SPELL.SetCooldown(4, 12)
    call thistype.THIS_SPELL.SetManaCost(4, 85)
    call thistype.THIS_SPELL.SetRange(4, 525)
    call thistype.THIS_SPELL.SetAreaRange(5, 500)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 110)
    call thistype.THIS_SPELL.SetRange(5, 525)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSe0', 5, 'VSe0')
    
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGETS_AMOUNT[2] = 3
    set thistype.TARGETS_AMOUNT[3] = 4
    set thistype.TARGETS_AMOUNT[4] = 4
    set thistype.TARGETS_AMOUNT[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\Severance.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\Severance.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSev'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Severance.page\\Severance.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\Severance.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod