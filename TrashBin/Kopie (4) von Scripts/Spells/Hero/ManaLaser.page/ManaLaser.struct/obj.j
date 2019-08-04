//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer START_OFFSET = 90
static integer array BURNED_MANA_MAX
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\NightElf\\ManaBurn\\ManaBurnTarget.mdl"
static integer array MAX_LENGTH
static integer array SPEED
static integer array DISPELLED_TARGETS_AMOUNT
static string EFFECT_LIGHTNING_PATH = "MBUR"
static integer HEIGHT = 50
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AMaL')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Mana Laser")
    call thistype.THIS_SPELL.SetOrder(OrderId("manaburn"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 90)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetAreaRange(2, 200)
    call thistype.THIS_SPELL.SetCooldown(2, 15)
    call thistype.THIS_SPELL.SetManaCost(2, 105)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 15)
    call thistype.THIS_SPELL.SetManaCost(3, 120)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetAreaRange(4, 200)
    call thistype.THIS_SPELL.SetCooldown(4, 15)
    call thistype.THIS_SPELL.SetManaCost(4, 135)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetAreaRange(5, 200)
    call thistype.THIS_SPELL.SetCooldown(5, 15)
    call thistype.THIS_SPELL.SetManaCost(5, 150)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNManaBurn.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FML0', 5, 'VML0')
    
    set thistype.BURNED_MANA_MAX[1] = 50
    set thistype.BURNED_MANA_MAX[2] = 80
    set thistype.BURNED_MANA_MAX[3] = 110
    set thistype.BURNED_MANA_MAX[4] = 140
    set thistype.BURNED_MANA_MAX[5] = 180
    set thistype.MAX_LENGTH[1] = 650
    set thistype.MAX_LENGTH[2] = 650
    set thistype.MAX_LENGTH[3] = 650
    set thistype.MAX_LENGTH[4] = 650
    set thistype.MAX_LENGTH[5] = 650
    set thistype.SPEED[1] = 900
    set thistype.SPEED[2] = 900
    set thistype.SPEED[3] = 900
    set thistype.SPEED[4] = 900
    set thistype.SPEED[5] = 900
    set thistype.DISPELLED_TARGETS_AMOUNT[1] = 3
    set thistype.DISPELLED_TARGETS_AMOUNT[2] = 3
    set thistype.DISPELLED_TARGETS_AMOUNT[3] = 4
    set thistype.DISPELLED_TARGETS_AMOUNT[4] = 4
    set thistype.DISPELLED_TARGETS_AMOUNT[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qMaL'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod