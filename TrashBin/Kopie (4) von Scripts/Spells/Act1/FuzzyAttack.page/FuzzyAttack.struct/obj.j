//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\FuzzyAttack.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real DELAY = 2.5
static integer INTERVALS_AMOUNT = 7
static integer DAMAGE_PER_MISSILE = 50
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\FuzzyAttack.page\\FuzzyAttack.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFuA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Fuzzy Attack")
    call thistype.THIS_SPELL.SetOrder(OrderId("thunderbolt"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetChannelTime(1, 4.25)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 150)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFurbolg.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\FuzzyAttack.page\\FuzzyAttack.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\FuzzyAttack.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\FuzzyAttack.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qFuA'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\FuzzyAttack.page\\FuzzyAttack.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\FuzzyAttack.page\\FuzzyAttack.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\FuzzyAttack.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod