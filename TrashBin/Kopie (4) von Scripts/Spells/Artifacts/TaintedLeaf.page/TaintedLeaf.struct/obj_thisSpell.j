static Spell THIS_SPELL
    
static integer array HEAL
static string HEAL_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string HEAL_TARGET_EFFECT_PATH = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
static real SELF_FACTOR = 0.7
static integer array SLEEP_HERO_DURATION
static integer array SLEEP_DURATION
static real array HEAL_FACTOR
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\TaintedLeaf.page\\TaintedLeaf.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATaL')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Tainted Leaf")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 6)
    call thistype.THIS_SPELL.SetManaCost(1, 70)
    call thistype.THIS_SPELL.SetRange(1, 800)
    call thistype.THIS_SPELL.SetCooldown(2, 6)
    call thistype.THIS_SPELL.SetManaCost(2, 70)
    call thistype.THIS_SPELL.SetRange(2, 800)
    call thistype.THIS_SPELL.SetCooldown(3, 6)
    call thistype.THIS_SPELL.SetManaCost(3, 70)
    call thistype.THIS_SPELL.SetRange(3, 800)
    call thistype.THIS_SPELL.SetCooldown(4, 6)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 800)
    call thistype.THIS_SPELL.SetCooldown(5, 6)
    call thistype.THIS_SPELL.SetManaCost(5, 70)
    call thistype.THIS_SPELL.SetRange(5, 800)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp")
    
    set thistype.HEAL[1] = 80
    set thistype.HEAL[2] = 100
    set thistype.HEAL[3] = 120
    set thistype.HEAL[4] = 140
    set thistype.HEAL[5] = 160
    set thistype.SLEEP_HERO_DURATION[1] = 1
    set thistype.SLEEP_HERO_DURATION[2] = 1
    set thistype.SLEEP_HERO_DURATION[3] = 1
    set thistype.SLEEP_HERO_DURATION[4] = 1
    set thistype.SLEEP_HERO_DURATION[5] = 1
    set thistype.SLEEP_DURATION[1] = 3
    set thistype.SLEEP_DURATION[2] = 3
    set thistype.SLEEP_DURATION[3] = 3
    set thistype.SLEEP_DURATION[4] = 3
    set thistype.SLEEP_DURATION[5] = 3
    set thistype.HEAL_FACTOR[1] = 0.05
    set thistype.HEAL_FACTOR[2] = 0.1
    set thistype.HEAL_FACTOR[3] = 0.15
    set thistype.HEAL_FACTOR[4] = 0.2
    set thistype.HEAL_FACTOR[5] = 0.25
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\TaintedLeaf.page\\TaintedLeaf.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod