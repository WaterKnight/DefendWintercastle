static Spell THIS_SPELL
    
static string SPECIAL_EFFECT2_PATH = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
static real array STUN_DURATION
static integer DURATION = 12
static integer array DAMAGE
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Thunderbringer.page\\Thunderbringer.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AThu')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Thunderbringer")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 100)
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 35)
    call thistype.THIS_SPELL.SetRange(1, 175)
    call thistype.THIS_SPELL.SetAreaRange(2, 150)
    call thistype.THIS_SPELL.SetCooldown(2, 8)
    call thistype.THIS_SPELL.SetManaCost(2, 45)
    call thistype.THIS_SPELL.SetRange(2, 175)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 8)
    call thistype.THIS_SPELL.SetManaCost(3, 55)
    call thistype.THIS_SPELL.SetRange(3, 175)
    call thistype.THIS_SPELL.SetAreaRange(4, 225)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 65)
    call thistype.THIS_SPELL.SetRange(4, 175)
    call thistype.THIS_SPELL.SetAreaRange(5, 250)
    call thistype.THIS_SPELL.SetCooldown(5, 8)
    call thistype.THIS_SPELL.SetManaCost(5, 75)
    call thistype.THIS_SPELL.SetRange(5, 175)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStormHammer.blp")
    
    set thistype.STUN_DURATION[1] = 2
    set thistype.STUN_DURATION[2] = 2.25
    set thistype.STUN_DURATION[3] = 2.5
    set thistype.STUN_DURATION[4] = 2.75
    set thistype.STUN_DURATION[5] = 3
    set thistype.DAMAGE[1] = 30
    set thistype.DAMAGE[2] = 60
    set thistype.DAMAGE[3] = 90
    set thistype.DAMAGE[4] = 120
    set thistype.DAMAGE[5] = 150
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\Thunderbringer.page\\Thunderbringer.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod