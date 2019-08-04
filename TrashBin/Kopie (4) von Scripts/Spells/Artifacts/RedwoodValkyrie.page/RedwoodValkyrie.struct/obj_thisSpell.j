static Spell THIS_SPELL
    
static integer array SPLASH_DAMAGE
static integer IGNITE_DURATION = 8
static string LAUNCH_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
static string MISSILE_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string LAUNCH_EFFECT_PATH = "Abilities\\Spells\\Other\\Incinerate\\IncinerateBuff.mdl"
static integer array SPLASH_AREA_RANGE
static real array DAMAGE_DAMAGE_MOD_FACTOR
static string MISSILE_EFFECT_PATH = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\RedwoodValkyrie.page\\RedwoodValkyrie.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ARwV')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Redwood Valkyrie")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT_OR_UNIT)
    call thistype.THIS_SPELL.SetAnimation("attack")
    call thistype.THIS_SPELL.SetAreaRange(1, 80)
    call thistype.THIS_SPELL.SetCooldown(1, 4)
    call thistype.THIS_SPELL.SetManaCost(1, 30)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetAreaRange(2, 80)
    call thistype.THIS_SPELL.SetCooldown(2, 4)
    call thistype.THIS_SPELL.SetManaCost(2, 40)
    call thistype.THIS_SPELL.SetRange(2, 900)
    call thistype.THIS_SPELL.SetAreaRange(3, 80)
    call thistype.THIS_SPELL.SetCooldown(3, 4)
    call thistype.THIS_SPELL.SetManaCost(3, 50)
    call thistype.THIS_SPELL.SetRange(3, 900)
    call thistype.THIS_SPELL.SetAreaRange(4, 80)
    call thistype.THIS_SPELL.SetCooldown(4, 4)
    call thistype.THIS_SPELL.SetManaCost(4, 60)
    call thistype.THIS_SPELL.SetRange(4, 900)
    call thistype.THIS_SPELL.SetAreaRange(5, 80)
    call thistype.THIS_SPELL.SetCooldown(5, 4)
    call thistype.THIS_SPELL.SetManaCost(5, 70)
    call thistype.THIS_SPELL.SetRange(5, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFlamingArrows.blp")
    
    set thistype.SPLASH_DAMAGE[1] = 20
    set thistype.SPLASH_DAMAGE[2] = 30
    set thistype.SPLASH_DAMAGE[3] = 40
    set thistype.SPLASH_DAMAGE[4] = 50
    set thistype.SPLASH_DAMAGE[5] = 60
    set thistype.SPLASH_AREA_RANGE[1] = 115
    set thistype.SPLASH_AREA_RANGE[2] = 115
    set thistype.SPLASH_AREA_RANGE[3] = 115
    set thistype.SPLASH_AREA_RANGE[4] = 115
    set thistype.SPLASH_AREA_RANGE[5] = 115
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[1] = 1.75
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[2] = 2
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[3] = 2.25
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[4] = 2.5
    set thistype.DAMAGE_DAMAGE_MOD_FACTOR[5] = 2.75
    set thistype.DAMAGE[1] = 15
    set thistype.DAMAGE[2] = 30
    set thistype.DAMAGE[3] = 45
    set thistype.DAMAGE[4] = 60
    set thistype.DAMAGE[5] = 75
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\RedwoodValkyrie.page\\RedwoodValkyrie.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod