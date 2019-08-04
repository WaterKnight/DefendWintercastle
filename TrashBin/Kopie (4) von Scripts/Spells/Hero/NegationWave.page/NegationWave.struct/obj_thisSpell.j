static Spell THIS_SPELL
    
static string SPELL_STEAL_CASTER_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string EFFECT_LIGHTNING_PATH = "FORK"
static integer array TARGETS_AMOUNT
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string SPELL_STEAL_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string TARGET_EFFECT_PATH = "Abilities\\Weapons\\Bolt\\BoltImpact.mdl"
static real array SILENCE_DURATION
static integer array DAMAGE
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
static string SPELL_STEAL_CASTER_EFFECT_PATH = "Abilities\\Spells\\Human\\SpellSteal\\SpellStealMissile.mdl"
static real DELAY = 0.35
static string SPELL_STEAL_TARGET_EFFECT_PATH = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphDoneGround.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\NegationWave.page\\NegationWave.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ANeW')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Negation Wave")
    call thistype.THIS_SPELL.SetOrder(OrderId("healingwave"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(1, 9)
    call thistype.THIS_SPELL.SetManaCost(1, 105)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetAreaRange(2, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 9)
    call thistype.THIS_SPELL.SetManaCost(2, 120)
    call thistype.THIS_SPELL.SetRange(2, 550)
    call thistype.THIS_SPELL.SetAreaRange(3, 500)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 135)
    call thistype.THIS_SPELL.SetRange(3, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFeedback.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FNW0', 3, 'VNW0')
    
    set thistype.TARGETS_AMOUNT[1] = 3
    set thistype.TARGETS_AMOUNT[2] = 4
    set thistype.TARGETS_AMOUNT[3] = 5
    set thistype.SILENCE_DURATION[1] = 2
    set thistype.SILENCE_DURATION[2] = 2.2
    set thistype.SILENCE_DURATION[3] = 2.4
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 40
    set thistype.DAMAGE[3] = 50
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\NegationWave.page\\NegationWave.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod