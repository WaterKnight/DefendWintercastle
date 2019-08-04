//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Other\\StrongDrink\\BrewmasterTarget.mdl"
static integer array DAMAGE
static real array POISON_DURATION
static integer DURATION = 3
static integer POISON_DAMAGE_ADD_FACTOR = 1
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASaB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Sake Bomb")
    call thistype.THIS_SPELL.SetOrder(OrderId("thunderclap"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetCooldown(1, 5)
    call thistype.THIS_SPELL.SetManaCost(1, 35)
    call thistype.THIS_SPELL.SetRange(1, 500)
    call thistype.THIS_SPELL.SetAreaRange(2, 225)
    call thistype.THIS_SPELL.SetCooldown(2, 5)
    call thistype.THIS_SPELL.SetManaCost(2, 40)
    call thistype.THIS_SPELL.SetRange(2, 500)
    call thistype.THIS_SPELL.SetAreaRange(3, 250)
    call thistype.THIS_SPELL.SetCooldown(3, 5)
    call thistype.THIS_SPELL.SetManaCost(3, 50)
    call thistype.THIS_SPELL.SetRange(3, 500)
    call thistype.THIS_SPELL.SetAreaRange(4, 275)
    call thistype.THIS_SPELL.SetCooldown(4, 5)
    call thistype.THIS_SPELL.SetManaCost(4, 65)
    call thistype.THIS_SPELL.SetRange(4, 500)
    call thistype.THIS_SPELL.SetAreaRange(5, 300)
    call thistype.THIS_SPELL.SetCooldown(5, 5)
    call thistype.THIS_SPELL.SetManaCost(5, 85)
    call thistype.THIS_SPELL.SetRange(5, 500)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDrum.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSB0', 5, 'VSB0')
    
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 60
    set thistype.DAMAGE[3] = 90
    set thistype.DAMAGE[4] = 120
    set thistype.DAMAGE[5] = 150
    set thistype.POISON_DURATION[1] = 4
    set thistype.POISON_DURATION[2] = 4.5
    set thistype.POISON_DURATION[3] = 5
    set thistype.POISON_DURATION[4] = 5.5
    set thistype.POISON_DURATION[5] = 6
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_areaDummyUnit.j
static constant integer AREA_DUMMY_UNIT_ID = 'qSBA'
    
    
static method Init_obj_areaDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\areaDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\areaDummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_areaDummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSaB'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SakeBomb.page\\SakeBomb.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_areaDummyUnit)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod