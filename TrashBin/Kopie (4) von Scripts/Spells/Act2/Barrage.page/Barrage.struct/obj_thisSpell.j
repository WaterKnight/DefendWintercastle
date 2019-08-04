static Spell THIS_SPELL
    
static integer OFFSET = 50
static integer COLOR_FADE_DURATION = 2
static integer DAMAGE_PER_SECOND = 100
static integer RED_INCREMENT = 0
static real INTERVAL = 0.3
static integer BLUE_INCREMENT = 0
static integer ALPHA_INCREMENT = 0
static integer GREEN_INCREMENT = 0
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Barrage.page\\Barrage.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABag')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Barrage")
    call thistype.THIS_SPELL.SetOrder(OrderId("thunderbolt"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 250)
    call thistype.THIS_SPELL.SetChannelTime(1, 5)
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 80)
    call thistype.THIS_SPELL.SetRange(1, 700)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFlakCannons.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\Barrage.page\\Barrage.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod