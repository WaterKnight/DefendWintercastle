static Spell THIS_SPELL
    
static string DAMAGE_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string DAMAGE_EFFECT_PATH = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
static real array ABSORPTION_FACTOR
static real INTERVAL = 0.75
static integer array DURATION
static real array DAMAGE_PER_INTERVAL
static real array MAX_HEAL_PER_INTERVAL
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWSh')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Wan Shroud")
    call thistype.THIS_SPELL.SetOrder(OrderId("banish"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 240)
    call thistype.THIS_SPELL.SetCooldown(1, 17)
    call thistype.THIS_SPELL.SetManaCost(1, 120)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetAreaRange(2, 260)
    call thistype.THIS_SPELL.SetCooldown(2, 17)
    call thistype.THIS_SPELL.SetManaCost(2, 135)
    call thistype.THIS_SPELL.SetRange(2, 900)
    call thistype.THIS_SPELL.SetAreaRange(3, 280)
    call thistype.THIS_SPELL.SetCooldown(3, 17)
    call thistype.THIS_SPELL.SetManaCost(3, 150)
    call thistype.THIS_SPELL.SetRange(3, 900)
    call thistype.THIS_SPELL.SetAreaRange(4, 300)
    call thistype.THIS_SPELL.SetCooldown(4, 17)
    call thistype.THIS_SPELL.SetManaCost(4, 165)
    call thistype.THIS_SPELL.SetRange(4, 900)
    call thistype.THIS_SPELL.SetAreaRange(5, 320)
    call thistype.THIS_SPELL.SetCooldown(5, 17)
    call thistype.THIS_SPELL.SetManaCost(5, 180)
    call thistype.THIS_SPELL.SetRange(5, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCyclone.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FWS0', 5, 'VWS0')
    
    set thistype.ABSORPTION_FACTOR[1] = 0.5
    set thistype.ABSORPTION_FACTOR[2] = 0.5
    set thistype.ABSORPTION_FACTOR[3] = 0.5
    set thistype.ABSORPTION_FACTOR[4] = 0.5
    set thistype.ABSORPTION_FACTOR[5] = 0.5
    set thistype.DURATION[1] = 10
    set thistype.DURATION[2] = 10
    set thistype.DURATION[3] = 10
    set thistype.DURATION[4] = 10
    set thistype.DURATION[5] = 10
    set thistype.DAMAGE_PER_INTERVAL[1] = 1.5
    set thistype.DAMAGE_PER_INTERVAL[2] = 2.5
    set thistype.DAMAGE_PER_INTERVAL[3] = 4
    set thistype.DAMAGE_PER_INTERVAL[4] = 6
    set thistype.DAMAGE_PER_INTERVAL[5] = 8.5
    set thistype.MAX_HEAL_PER_INTERVAL[1] = 7.5
    set thistype.MAX_HEAL_PER_INTERVAL[2] = 10
    set thistype.MAX_HEAL_PER_INTERVAL[3] = 12.5
    set thistype.MAX_HEAL_PER_INTERVAL[4] = 15
    set thistype.MAX_HEAL_PER_INTERVAL[5] = 17.5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\WanShroud.page\\WanShroud.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod