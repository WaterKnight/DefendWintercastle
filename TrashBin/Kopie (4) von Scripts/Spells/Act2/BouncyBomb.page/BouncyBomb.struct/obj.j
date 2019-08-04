//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\BouncyBomb.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string EXPLOSION_EFFECT_PATH = "Objects\\Spawnmodels\\Human\\FragmentationShards\\FragBoomSpawn.mdl"
static integer FLOOR_TOLERANCE = 1
static integer FIRST_BOUNCE_DURATION = 1
static integer MAX_DAMAGE = 120
static integer Z_ACCELERATION = -1000
static integer EXPLOSION_DURATION = 3
static integer DAMAGE = 40
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BouncyBomb.page\\BouncyBomb.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABoB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Bouncy Bomb")
    call thistype.THIS_SPELL.SetOrder(OrderId("firebolt"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 100)
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 25)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHealthStone.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BouncyBomb.page\\BouncyBomb.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\BouncyBomb.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\BouncyBomb.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qByB'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BouncyBomb.page\\BouncyBomb.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\BouncyBomb.page\\BouncyBomb.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\BouncyBomb.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod