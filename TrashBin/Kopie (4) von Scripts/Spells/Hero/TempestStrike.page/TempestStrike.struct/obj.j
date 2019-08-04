//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer SPEED_END = 200
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static real DURATION = 0.75
static integer LENGTH = 600
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATeS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Tempest Strike")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 90)
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 70)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetAreaRange(2, 90)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 85)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetAreaRange(3, 90)
    call thistype.THIS_SPELL.SetCooldown(3, 10)
    call thistype.THIS_SPELL.SetManaCost(3, 100)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetAreaRange(4, 90)
    call thistype.THIS_SPELL.SetCooldown(4, 10)
    call thistype.THIS_SPELL.SetManaCost(4, 115)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetAreaRange(5, 90)
    call thistype.THIS_SPELL.SetCooldown(5, 10)
    call thistype.THIS_SPELL.SetManaCost(5, 130)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCleavingAttack.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FTe0', 5, 'VTe0')
    
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 60
    set thistype.DAMAGE[3] = 90
    set thistype.DAMAGE[4] = 120
    set thistype.DAMAGE[5] = 150
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\TempestStrike.page\\TempestStrike.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod