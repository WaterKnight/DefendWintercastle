static Spell THIS_SPELL
    
static integer OFFSET = 260
static integer array SUMMONS_AMOUNT
static real MOVE_DURATION = 0.4
static real WINDOW_PER_SUMMON = 0.36 * Math.QUARTER_ANGLE
static string BARRIER_EFFECT_PATH = "Abilities\\Spells\\Human\\Avatar\\AvatarCaster.mdl"
static real array DURATION
static integer CASTER_OFFSET = 150
static string BARRIER_EFFECT_ATTACH_POINT = "AttachPoint.OVERHEAD"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABar')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Barrier")
    call thistype.THIS_SPELL.SetOrder(OrderId("summonfactory"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 8)
    call thistype.THIS_SPELL.SetManaCost(2, 30)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 8)
    call thistype.THIS_SPELL.SetManaCost(3, 40)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 50)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 8)
    call thistype.THIS_SPELL.SetManaCost(5, 60)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFrostMourne.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FBa0', 5, 'VBa0')
    
    set thistype.SUMMONS_AMOUNT[1] = 3
    set thistype.SUMMONS_AMOUNT[2] = 3
    set thistype.SUMMONS_AMOUNT[3] = 4
    set thistype.SUMMONS_AMOUNT[4] = 4
    set thistype.SUMMONS_AMOUNT[5] = 5
    set thistype.DURATION[1] = 3
    set thistype.DURATION[2] = 3.5
    set thistype.DURATION[3] = 4
    set thistype.DURATION[4] = 4.5
    set thistype.DURATION[5] = 5
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Barrier.page\\Barrier.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod