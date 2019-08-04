static Spell THIS_SPELL
    
static integer array MAX_LENGTH
static integer array SPEED
static integer WIDTH_END = 300
static integer WIDTH_START = 0
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\ChillyBreath.page\\ChillyBreath.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AChB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Chilly Breath")
    call thistype.THIS_SPELL.SetOrder(OrderId("breathoffrost"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 14)
    call thistype.THIS_SPELL.SetManaCost(1, 20)
    call thistype.THIS_SPELL.SetRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(2, 14)
    call thistype.THIS_SPELL.SetManaCost(2, 30)
    call thistype.THIS_SPELL.SetRange(2, 550)
    call thistype.THIS_SPELL.SetCooldown(3, 14)
    call thistype.THIS_SPELL.SetManaCost(3, 40)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetCooldown(4, 14)
    call thistype.THIS_SPELL.SetManaCost(4, 50)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetCooldown(5, 14)
    call thistype.THIS_SPELL.SetManaCost(5, 60)
    call thistype.THIS_SPELL.SetRange(5, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FCB0', 5, 'VCB0')
    
    set thistype.MAX_LENGTH[1] = 600
    set thistype.MAX_LENGTH[2] = 650
    set thistype.MAX_LENGTH[3] = 700
    set thistype.MAX_LENGTH[4] = 750
    set thistype.MAX_LENGTH[5] = 800
    set thistype.SPEED[1] = 650
    set thistype.SPEED[2] = 650
    set thistype.SPEED[3] = 650
    set thistype.SPEED[4] = 650
    set thistype.SPEED[5] = 650
    set thistype.DAMAGE[1] = 35
    set thistype.DAMAGE[2] = 60
    set thistype.DAMAGE[3] = 85
    set thistype.DAMAGE[4] = 110
    set thistype.DAMAGE[5] = 135
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\ChillyBreath.page\\ChillyBreath.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod