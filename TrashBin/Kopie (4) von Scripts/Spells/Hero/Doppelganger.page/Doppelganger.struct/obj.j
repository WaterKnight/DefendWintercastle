//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_dummyUnit.j
static constant integer DUMMY_UNIT_ID = 'qDoG'
    
    
static method Init_obj_dummyUnit takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\dummyUnit.wc3unit")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\dummyUnit.wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_dummyUnit.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real array ILLUSION_DAMAGE_FACTOR
static integer array DURATION
static integer MIN_RANGE = 200
static string ILLUSION_DEATH_EFFECT_PATH = "Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ADoG')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Doppelganger")
    call thistype.THIS_SPELL.SetOrder(OrderId("mirrorimage"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 500)
    call thistype.THIS_SPELL.SetCooldown(3, 10)
    call thistype.THIS_SPELL.SetManaCost(3, 50)
    call thistype.THIS_SPELL.SetRange(3, 500)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNAvengingWatcher.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FDG0', 3, 'VDG0')
    
    set thistype.ILLUSION_DAMAGE_FACTOR[1] = 0.3
    set thistype.ILLUSION_DAMAGE_FACTOR[2] = 0.5
    set thistype.ILLUSION_DAMAGE_FACTOR[3] = 0.7
    set thistype.DURATION[1] = 30
    set thistype.DURATION[2] = 30
    set thistype.DURATION[3] = 30
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_illusionBuff.j
static Buff ILLUSION_BUFF
    
    
static method Init_obj_illusionBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\illusionBuff.wc3buff")
    set thistype.ILLUSION_BUFF = Buff.Create('BDGI', "Doppelganger", 'bDGI')
    call thistype.ILLUSION_BUFF.SetPositive(true)
    call thistype.ILLUSION_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDoom.blp")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Doppelganger.page\\Doppelganger.struct\\illusionBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\obj_illusionBuff.j


private static method onInit takes nothing returns nothing
    call UnitType.AddInit(function thistype.Init_obj_dummyUnit)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_illusionBuff)
endmethod