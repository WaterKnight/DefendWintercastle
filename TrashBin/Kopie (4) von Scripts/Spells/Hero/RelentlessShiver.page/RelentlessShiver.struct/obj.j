//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BReS', "Relentless Shiver", 'bReS')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string SPECIAL_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
static integer array MAX_TARGETS_AMOUNT
static real INTERVAL = 0.75
static integer array MANA_COST_PER_SECOND
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
static integer MANA_COST_BUFFER = 10
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AReS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Relentless Shiver")
    call thistype.THIS_SPELL.SetOrder(OrderId("animatedead"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(1, 80)
    call thistype.THIS_SPELL.SetManaCost(1, 10)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 80)
    call thistype.THIS_SPELL.SetManaCost(2, 10)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 500)
    call thistype.THIS_SPELL.SetCooldown(3, 80)
    call thistype.THIS_SPELL.SetManaCost(3, 10)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAnimateDead.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FRS0', 3, 'VRS0')
    
    set thistype.MAX_TARGETS_AMOUNT[1] = 5
    set thistype.MAX_TARGETS_AMOUNT[2] = 8
    set thistype.MAX_TARGETS_AMOUNT[3] = 11
    set thistype.MANA_COST_PER_SECOND[1] = 8
    set thistype.MANA_COST_PER_SECOND[2] = 13
    set thistype.MANA_COST_PER_SECOND[3] = 18
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RelentlessShiver.page\\RelentlessShiver.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod