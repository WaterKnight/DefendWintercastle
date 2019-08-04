//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real STOLEN_MANA_ABSORPTION_FACTOR = 0.15
static integer array STOLEN_MANA
static integer array DURATION
static real array PULL_FACTOR
static integer INTERVAL = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATsu')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Tsukuyomi")
    call thistype.THIS_SPELL.SetOrder(OrderId("banish"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 275)
    call thistype.THIS_SPELL.SetCooldown(1, 80)
    call thistype.THIS_SPELL.SetManaCost(1, 200)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetAreaRange(2, 350)
    call thistype.THIS_SPELL.SetCooldown(2, 80)
    call thistype.THIS_SPELL.SetManaCost(2, 300)
    call thistype.THIS_SPELL.SetRange(2, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBanish.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FTs0', 2, 'VTs0')
    
    set thistype.STOLEN_MANA[1] = 10
    set thistype.STOLEN_MANA[2] = 20
    set thistype.DURATION[1] = 15
    set thistype.DURATION[2] = 20
    set thistype.PULL_FACTOR[1] = 0.35
    set thistype.PULL_FACTOR[2] = 0.45
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_movingDummyUnit.j
static constant integer MOVING_DUMMY_UNIT_ID = 'qTsP'
    
    
static method Init_obj_movingDummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\movingDummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\movingDummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_movingDummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qTsu'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyUnit2.j
static constant integer DUMMY_UNIT2_ID = 'qTs2'
    
    
static method Init_obj_dummyUnit2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit2.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\dummyUnit2.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\obj_dummyUnit2.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_movingDummyUnit)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit2)
endmethod