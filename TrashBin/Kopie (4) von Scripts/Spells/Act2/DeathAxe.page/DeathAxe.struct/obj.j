//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\DeathAxe.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qDeA'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DeathAxe.page\\DeathAxe.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DeathAxe.page\\DeathAxe.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\DeathAxe.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\DeathAxe.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer DISARM_DURATION = 3
static integer DELAY = 1
static integer DAMAGE = 70
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DeathAxe.page\\DeathAxe.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ADeA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Death Axe")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 80)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSpiritWalkerMasterTraining.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\DeathAxe.page\\DeathAxe.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\DeathAxe.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod