static Spell THIS_SPELL
    
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string EFFECT_LIGHTNING_PATH = "HWSB"
static integer array RESTORED_LIFE
static integer array TARGETS_AMOUNT
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
static string FIRST_LIGHTNING_PATH = "SPLK"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Tranquility\\TranquilityTarget.mdl"
static integer DAMAGE_AREA_WIDTH = 75
static real array STUN_DURATION
static real RESTORED_LIFE_ADD_FACTOR = -0.15
static real DELAY = 0.35
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\KhakiRecovery.page\\KhakiRecovery.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ARec')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Khaki Recovery")
    call thistype.THIS_SPELL.SetOrder(OrderId("healingwave"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(1, 6)
    call thistype.THIS_SPELL.SetManaCost(1, 105)
    call thistype.THIS_SPELL.SetRange(1, 650)
    call thistype.THIS_SPELL.SetAreaRange(2, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 6)
    call thistype.THIS_SPELL.SetManaCost(2, 120)
    call thistype.THIS_SPELL.SetRange(2, 650)
    call thistype.THIS_SPELL.SetAreaRange(3, 500)
    call thistype.THIS_SPELL.SetCooldown(3, 6)
    call thistype.THIS_SPELL.SetManaCost(3, 135)
    call thistype.THIS_SPELL.SetRange(3, 650)
    call thistype.THIS_SPELL.SetAreaRange(4, 500)
    call thistype.THIS_SPELL.SetCooldown(4, 6)
    call thistype.THIS_SPELL.SetManaCost(4, 150)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetAreaRange(5, 500)
    call thistype.THIS_SPELL.SetCooldown(5, 6)
    call thistype.THIS_SPELL.SetManaCost(5, 165)
    call thistype.THIS_SPELL.SetRange(5, 650)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMagicImmunity.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FRc0', 5, 'VRc0')
    
    set thistype.RESTORED_LIFE[1] = 120
    set thistype.RESTORED_LIFE[2] = 180
    set thistype.RESTORED_LIFE[3] = 240
    set thistype.RESTORED_LIFE[4] = 300
    set thistype.RESTORED_LIFE[5] = 360
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGETS_AMOUNT[2] = 3
    set thistype.TARGETS_AMOUNT[3] = 4
    set thistype.TARGETS_AMOUNT[4] = 4
    set thistype.TARGETS_AMOUNT[5] = 5
    set thistype.STUN_DURATION[1] = 1
    set thistype.STUN_DURATION[2] = 1.25
    set thistype.STUN_DURATION[3] = 1.5
    set thistype.STUN_DURATION[4] = 1.75
    set thistype.STUN_DURATION[5] = 2
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 45
    set thistype.DAMAGE[3] = 60
    set thistype.DAMAGE[4] = 75
    set thistype.DAMAGE[5] = 90
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\KhakiRecovery.page\\KhakiRecovery.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod