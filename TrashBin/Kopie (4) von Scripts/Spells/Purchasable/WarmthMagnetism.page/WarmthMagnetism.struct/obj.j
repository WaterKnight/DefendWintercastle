//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\WarmthMagnetism.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\WarmthMagnetism.page\\WarmthMagnetism.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\WarmthMagnetism.page\\WarmthMagnetism.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\WarmthMagnetism.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\WarmthMagnetism.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array DAMAGE_PER_INTERVAL
static real DAMAGE_INTERVAL = 0.5
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
static string EFFECT_LIGHTNING_PATH = "MBUR"
static integer SPEED = 300
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer HIT_RANGE = 120
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\WarmthMagnetism.page\\WarmthMagnetism.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWaM')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Warmth Magnetism")
    call thistype.THIS_SPELL.SetOrder(OrderId("darkportal"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 6)
    call thistype.THIS_SPELL.SetManaCost(1, 50)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetCooldown(2, 6)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 600)
    call thistype.THIS_SPELL.SetCooldown(3, 6)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetCooldown(4, 6)
    call thistype.THIS_SPELL.SetManaCost(4, 60)
    call thistype.THIS_SPELL.SetRange(4, 600)
    call thistype.THIS_SPELL.SetCooldown(5, 6)
    call thistype.THIS_SPELL.SetManaCost(5, 70)
    call thistype.THIS_SPELL.SetRange(5, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNGnollCommandAura.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FWM0', 5, 'VWM0')
    
    set thistype.DAMAGE_PER_INTERVAL[1] = 20
    set thistype.DAMAGE_PER_INTERVAL[2] = 30
    set thistype.DAMAGE_PER_INTERVAL[3] = 40
    set thistype.DAMAGE_PER_INTERVAL[4] = 50
    set thistype.DAMAGE_PER_INTERVAL[5] = 60
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\WarmthMagnetism.page\\WarmthMagnetism.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\WarmthMagnetism.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod