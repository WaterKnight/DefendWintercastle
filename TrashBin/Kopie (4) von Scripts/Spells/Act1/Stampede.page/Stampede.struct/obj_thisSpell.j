static Spell THIS_SPELL
    
static integer SPEED_ADD = 300
static real DAMAGE_SPEED_FACTOR_PER_SECOND = 0.2
static string SPECIAL_EFFECT_PATH = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl"
static string TARGET_EFFECT_PATH = "Abilities\\Weapons\\HydraliskImpact\\HydraliskImpact.mdl"
static real SPECIAL_EFFECT_SCALE = 0.5
static real INTERVAL = 0.035
static integer MAX_LENGTH = 1300
static integer SPEED = 500
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Stampede.page\\Stampede.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AStm')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Stampede")
    call thistype.THIS_SPELL.SetOrder(OrderId("stampede"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 1000)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNSmash.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\Stampede.page\\Stampede.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod