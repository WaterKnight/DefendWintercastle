static Spell THIS_SPELL
    
static integer array ACCELERATION
static integer DUMMY_UNIT_DURATION = 1
static integer ANIMATION_INCREMENT = 1
static integer array SPEED
static integer DUMMY_UNIT_OFFSET = -75
static real EFFECT_INTERVAL = 0.125
static integer ARRIVAL_TOLERANCE = 5
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('APaP')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Panda Paw")
    call thistype.THIS_SPELL.SetOrder(OrderId("drunkenhaze"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("attack")
    call thistype.THIS_SPELL.SetAreaRange(1, 400)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 125)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetAreaRange(2, 400)
    call thistype.THIS_SPELL.SetCooldown(2, 14)
    call thistype.THIS_SPELL.SetManaCost(2, 150)
    call thistype.THIS_SPELL.SetRange(2, 600)
    call thistype.THIS_SPELL.SetAreaRange(3, 400)
    call thistype.THIS_SPELL.SetCooldown(3, 13)
    call thistype.THIS_SPELL.SetManaCost(3, 175)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBearForm.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FPP0', 3, 'VPP0')
    
    set thistype.ACCELERATION[1] = 500
    set thistype.ACCELERATION[2] = 500
    set thistype.ACCELERATION[3] = 500
    set thistype.SPEED[1] = 500
    set thistype.SPEED[2] = 500
    set thistype.SPEED[3] = 500
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\PandaPaw.page\\PandaPaw.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod