static Spell THIS_SPELL
    
static integer array MAX_DAMAGE
static integer DAMAGE_DAMAGE_MOD_FACTOR = 1
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
static real array DAMAGE_IGNITE_BONUS
static integer array MAX_LENGTH
static string SPECIAL_EFFECT2_PATH = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl"
static integer array SPEED
static real INTERVAL = 0.2
static integer array HORIZONTAL_MAX_WIDTH
static real array HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FlameTongue.page\\FlameTongue.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFlT')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Flame Tongue")
    call thistype.THIS_SPELL.SetOrder(OrderId("clusterrockets"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 30)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetAreaRange(2, 200)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 45)
    call thistype.THIS_SPELL.SetRange(2, 700)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 10)
    call thistype.THIS_SPELL.SetManaCost(3, 55)
    call thistype.THIS_SPELL.SetRange(3, 700)
    call thistype.THIS_SPELL.SetAreaRange(4, 200)
    call thistype.THIS_SPELL.SetCooldown(4, 10)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 700)
    call thistype.THIS_SPELL.SetAreaRange(5, 200)
    call thistype.THIS_SPELL.SetCooldown(5, 10)
    call thistype.THIS_SPELL.SetManaCost(5, 90)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMarkOfFire.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FFT0', 5, 'VFT0')
    
    set thistype.MAX_DAMAGE[1] = 500
    set thistype.MAX_DAMAGE[2] = 900
    set thistype.MAX_DAMAGE[3] = 1500
    set thistype.MAX_DAMAGE[4] = 2200
    set thistype.MAX_DAMAGE[5] = 3000
    set thistype.DAMAGE_IGNITE_BONUS[1] = 0.5
    set thistype.DAMAGE_IGNITE_BONUS[2] = 0.6
    set thistype.DAMAGE_IGNITE_BONUS[3] = 0.7
    set thistype.DAMAGE_IGNITE_BONUS[4] = 0.8
    set thistype.DAMAGE_IGNITE_BONUS[5] = 0.9
    set thistype.MAX_LENGTH[1] = 600
    set thistype.MAX_LENGTH[2] = 600
    set thistype.MAX_LENGTH[3] = 600
    set thistype.MAX_LENGTH[4] = 600
    set thistype.MAX_LENGTH[5] = 600
    set thistype.SPEED[1] = 700
    set thistype.SPEED[2] = 700
    set thistype.SPEED[3] = 700
    set thistype.SPEED[4] = 700
    set thistype.SPEED[5] = 700
    set thistype.HORIZONTAL_MAX_WIDTH[1] = 500
    set thistype.HORIZONTAL_MAX_WIDTH[2] = 500
    set thistype.HORIZONTAL_MAX_WIDTH[3] = 500
    set thistype.HORIZONTAL_MAX_WIDTH[4] = 500
    set thistype.HORIZONTAL_MAX_WIDTH[5] = 500
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[1] = 0.5
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[2] = 0.5
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[3] = 0.5
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[4] = 0.5
    set thistype.HORIZONTAL_MAX_WIDTH_LENGTH_FACTOR[5] = 0.5
    set thistype.DAMAGE[1] = 35
    set thistype.DAMAGE[2] = 50
    set thistype.DAMAGE[3] = 65
    set thistype.DAMAGE[4] = 80
    set thistype.DAMAGE[5] = 95
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\FlameTongue.page\\FlameTongue.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod