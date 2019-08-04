static Spell THIS_SPELL
    
static integer ACCELERATION = -1200
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real BUFF_DURATION = 0.5
static integer DURATION = 3
static string CASTER_EFFECT2_ATTACH_POINT = "AttachPoint.ORIGIN"
static string CASTER_BUFF_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl"
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosTarget.mdl"
static string CASTER_EFFECT2_PATH = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
static string TARGET_EFFECT_PATH = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
static string CASTER_BUFF_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer SPEED = 600
static real INTERVAL = 0.125
static real DELAY = 0.5
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\HeatExplosion.page\\HeatExplosion.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHeE')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Heat Explosion")
    call thistype.THIS_SPELL.SetOrder(OrderId("inferno"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetCooldown(1, 9)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 200)
    call thistype.THIS_SPELL.SetCooldown(2, 9)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetAreaRange(4, 200)
    call thistype.THIS_SPELL.SetCooldown(4, 9)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetAreaRange(5, 200)
    call thistype.THIS_SPELL.SetCooldown(5, 9)
    call thistype.THIS_SPELL.SetManaCost(5, 80)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNImmolationOn.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FHE0', 5, 'VHE0')
    
    set thistype.DAMAGE[1] = 5
    set thistype.DAMAGE[2] = 8
    set thistype.DAMAGE[3] = 13
    set thistype.DAMAGE[4] = 20
    set thistype.DAMAGE[5] = 28
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\HeatExplosion.page\\HeatExplosion.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod