static Spell THIS_SPELL
    
static real STOLEN_MANA_ABSORPTION_FACTOR = 0.15
static integer array STOLEN_MANA
static integer array DURATION
static real array PULL_FACTOR
static integer INTERVAL = 1
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ATsu')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Tsukuyomi")
    call thistype.THIS_SPELL.SetOrder(OrderId("banish"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 275)
    call thistype.THIS_SPELL.SetCooldown(1, 80)
    call thistype.THIS_SPELL.SetManaCost(1, 200)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetAreaRange(2, 350)
    call thistype.THIS_SPELL.SetCooldown(2, 80)
    call thistype.THIS_SPELL.SetManaCost(2, 300)
    call thistype.THIS_SPELL.SetRange(2, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBanish.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FTs0', 2, 'VTs0')
    
    set thistype.STOLEN_MANA[1] = 10
    set thistype.STOLEN_MANA[2] = 20
    set thistype.DURATION[1] = 15
    set thistype.DURATION[2] = 20
    set thistype.PULL_FACTOR[1] = 0.35
    set thistype.PULL_FACTOR[2] = 0.45
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Tsukuyomi.page\\Tsukuyomi.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod