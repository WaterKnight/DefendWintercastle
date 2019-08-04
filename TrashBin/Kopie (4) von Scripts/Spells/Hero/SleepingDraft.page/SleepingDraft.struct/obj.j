//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array TARGETS_AMOUNT
static integer array DURATION
static real array HERO_DURATION
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASlD')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Sleeping Draft")
    call thistype.THIS_SPELL.SetOrder(OrderId("sleep"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 350)
    call thistype.THIS_SPELL.SetCooldown(1, 16)
    call thistype.THIS_SPELL.SetManaCost(1, 120)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetAreaRange(2, 350)
    call thistype.THIS_SPELL.SetCooldown(2, 15)
    call thistype.THIS_SPELL.SetManaCost(2, 120)
    call thistype.THIS_SPELL.SetRange(2, 600)
    call thistype.THIS_SPELL.SetAreaRange(3, 350)
    call thistype.THIS_SPELL.SetCooldown(3, 14)
    call thistype.THIS_SPELL.SetManaCost(3, 120)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetAreaRange(4, 350)
    call thistype.THIS_SPELL.SetCooldown(4, 13)
    call thistype.THIS_SPELL.SetManaCost(4, 120)
    call thistype.THIS_SPELL.SetRange(4, 600)
    call thistype.THIS_SPELL.SetAreaRange(5, 350)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 120)
    call thistype.THIS_SPELL.SetRange(5, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfClarity.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSD0', 5, 'VSD0')
    
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGETS_AMOUNT[2] = 4
    set thistype.TARGETS_AMOUNT[3] = 5
    set thistype.TARGETS_AMOUNT[4] = 6
    set thistype.TARGETS_AMOUNT[5] = 7
    set thistype.DURATION[1] = 5
    set thistype.DURATION[2] = 6
    set thistype.DURATION[3] = 7
    set thistype.DURATION[4] = 8
    set thistype.DURATION[5] = 9
    set thistype.HERO_DURATION[1] = 1
    set thistype.HERO_DURATION[2] = 1.5
    set thistype.HERO_DURATION[3] = 2
    set thistype.HERO_DURATION[4] = 2.5
    set thistype.HERO_DURATION[5] = 3
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSDB', "Sleep", 'bSDB')
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNPotionOfClarity.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qSle'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\SleepingDraft.page\\SleepingDraft.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.struct\obj_dummyUnit.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
endmethod