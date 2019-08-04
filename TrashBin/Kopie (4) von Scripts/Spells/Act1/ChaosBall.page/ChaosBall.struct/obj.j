//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\ChaosBall.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qCha'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\ChaosBall.page\\ChaosBall.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\ChaosBall.page\\ChaosBall.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\ChaosBall.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\ChaosBall.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer OFFSET_Z = 80
static string SPECIAL_EFFECT_PATH = "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl"
static integer DURATION = 3
static integer DAMAGE = 65
static integer RANGE_TOLERANCE = 300
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\ChaosBall.page\\ChaosBall.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AKao')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Chaos Ball")
    call thistype.THIS_SPELL.SetOrder(OrderId("deathcoil"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 100)
    call thistype.THIS_SPELL.SetChannelTime(1, 0.75)
    call thistype.THIS_SPELL.SetCooldown(1, 20)
    call thistype.THIS_SPELL.SetManaCost(1, 100)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNOrbOfDeath.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\ChaosBall.page\\ChaosBall.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\ChaosBall.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod