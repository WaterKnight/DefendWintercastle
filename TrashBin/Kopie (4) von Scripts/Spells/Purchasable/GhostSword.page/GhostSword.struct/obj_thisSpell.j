static Spell THIS_SPELL
    
static string VICTIM_EFFECT_PATH = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
static string SUMMON_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
static real array DAMAGE_FACTOR
static integer array DURATION
static string DEATH_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
static string SUMMON_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
static integer array SUMMONS_AMOUNT
static string VICTIM_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array STOLEN_MANA
static integer SUMMON_OFFSET = 100
static string DEATH_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AGhS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Ghost Sword")
    call thistype.THIS_SPELL.SetOrder(OrderId("summonwareagle"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 12)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 12)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 12)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 80)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FGS0', 5, 'VGS0')
    
    set thistype.DAMAGE_FACTOR[1] = 1
    set thistype.DAMAGE_FACTOR[2] = 1.5
    set thistype.DAMAGE_FACTOR[3] = 2
    set thistype.DAMAGE_FACTOR[4] = 2.5
    set thistype.DAMAGE_FACTOR[5] = 3
    set thistype.DURATION[1] = 25
    set thistype.DURATION[2] = 25
    set thistype.DURATION[3] = 25
    set thistype.DURATION[4] = 25
    set thistype.DURATION[5] = 25
    set thistype.SUMMONS_AMOUNT[1] = 2
    set thistype.SUMMONS_AMOUNT[2] = 2
    set thistype.SUMMONS_AMOUNT[3] = 3
    set thistype.SUMMONS_AMOUNT[4] = 3
    set thistype.SUMMONS_AMOUNT[5] = 4
    set thistype.STOLEN_MANA[1] = 10
    set thistype.STOLEN_MANA[2] = 15
    set thistype.STOLEN_MANA[3] = 20
    set thistype.STOLEN_MANA[4] = 25
    set thistype.STOLEN_MANA[5] = 30
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod