static Spell THIS_SPELL
    
static integer array MAX_LENGTH
static integer array DAMAGE
static string TARGET_EFFECT_PATH = "Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\RazorBlade.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ARaz')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Razor Blade")
    call thistype.THIS_SPELL.SetOrder(OrderId("evileye"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 90)
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 70)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetAreaRange(2, 90)
    call thistype.THIS_SPELL.SetCooldown(2, 12)
    call thistype.THIS_SPELL.SetManaCost(2, 85)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetAreaRange(3, 90)
    call thistype.THIS_SPELL.SetCooldown(3, 12)
    call thistype.THIS_SPELL.SetManaCost(3, 100)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetAreaRange(4, 90)
    call thistype.THIS_SPELL.SetCooldown(4, 12)
    call thistype.THIS_SPELL.SetManaCost(4, 115)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetAreaRange(5, 90)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 130)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNWhirlwind.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FRB0', 5, 'VRB0')
    
    set thistype.MAX_LENGTH[1] = 750
    set thistype.MAX_LENGTH[2] = 750
    set thistype.MAX_LENGTH[3] = 750
    set thistype.MAX_LENGTH[4] = 750
    set thistype.MAX_LENGTH[5] = 750
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 35
    set thistype.DAMAGE[3] = 55
    set thistype.DAMAGE[4] = 80
    set thistype.DAMAGE[5] = 110
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RazorBlade.page\\RazorBlade.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod