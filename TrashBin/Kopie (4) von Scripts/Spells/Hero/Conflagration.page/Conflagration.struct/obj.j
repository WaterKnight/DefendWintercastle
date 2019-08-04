//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\Conflagration.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qCon'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Conflagration.page\\Conflagration.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Conflagration.page\\Conflagration.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\Conflagration.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\Conflagration.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer OFFSET = 100
static integer array MAX_LENGTH
static integer WIDTH_START = 0
static integer array SPEED
static integer WIDTH_END = 300
static real array IGNITION_DURATION
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Conflagration.page\\Conflagration.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ACon')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Conflagration")
    call thistype.THIS_SPELL.SetOrder(OrderId("breathoffire"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 9)
    call thistype.THIS_SPELL.SetManaCost(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 9)
    call thistype.THIS_SPELL.SetManaCost(2, 30)
    call thistype.THIS_SPELL.SetRange(2, 550)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 40)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetCooldown(4, 9)
    call thistype.THIS_SPELL.SetManaCost(4, 50)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetCooldown(5, 9)
    call thistype.THIS_SPELL.SetManaCost(5, 60)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWallOfFire.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FCB0', 5, 'VCB0')
    
    set thistype.MAX_LENGTH[1] = 400
    set thistype.MAX_LENGTH[2] = 425
    set thistype.MAX_LENGTH[3] = 450
    set thistype.MAX_LENGTH[4] = 475
    set thistype.MAX_LENGTH[5] = 500
    set thistype.SPEED[1] = 650
    set thistype.SPEED[2] = 650
    set thistype.SPEED[3] = 650
    set thistype.SPEED[4] = 650
    set thistype.SPEED[5] = 650
    set thistype.IGNITION_DURATION[1] = 4
    set thistype.IGNITION_DURATION[2] = 4.5
    set thistype.IGNITION_DURATION[3] = 5
    set thistype.IGNITION_DURATION[4] = 5.5
    set thistype.IGNITION_DURATION[5] = 6
    set thistype.DAMAGE[1] = 35
    set thistype.DAMAGE[2] = 60
    set thistype.DAMAGE[3] = 85
    set thistype.DAMAGE[4] = 110
    set thistype.DAMAGE[5] = 135
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Conflagration.page\\Conflagration.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\Conflagration.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod