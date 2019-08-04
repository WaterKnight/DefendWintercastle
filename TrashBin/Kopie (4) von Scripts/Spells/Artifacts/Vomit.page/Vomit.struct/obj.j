//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\Vomit.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qVom'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Vomit.page\\Vomit.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Vomit.page\\Vomit.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\Vomit.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\Vomit.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array POISON_HERO_DURATION
static integer array POISON_DURATION
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Vomit.page\\Vomit.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AVom')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Vomit")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 5)
    call thistype.THIS_SPELL.SetManaCost(1, 15)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetCooldown(2, 5)
    call thistype.THIS_SPELL.SetManaCost(2, 20)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetCooldown(3, 5)
    call thistype.THIS_SPELL.SetManaCost(3, 25)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetCooldown(4, 5)
    call thistype.THIS_SPELL.SetManaCost(4, 30)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetCooldown(5, 5)
    call thistype.THIS_SPELL.SetManaCost(5, 35)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCorrosiveBreath.blp")
    
    set thistype.POISON_HERO_DURATION[1] = 2
    set thistype.POISON_HERO_DURATION[2] = 2
    set thistype.POISON_HERO_DURATION[3] = 2
    set thistype.POISON_HERO_DURATION[4] = 2
    set thistype.POISON_HERO_DURATION[5] = 2
    set thistype.POISON_DURATION[1] = 3
    set thistype.POISON_DURATION[2] = 4
    set thistype.POISON_DURATION[3] = 5
    set thistype.POISON_DURATION[4] = 6
    set thistype.POISON_DURATION[5] = 7
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 50
    set thistype.DAMAGE[4] = 60
    set thistype.DAMAGE[5] = 70
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Vomit.page\\Vomit.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\Vomit.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod