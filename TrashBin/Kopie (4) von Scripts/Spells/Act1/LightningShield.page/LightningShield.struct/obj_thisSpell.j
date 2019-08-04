static Spell THIS_SPELL
    
static real INTERVAL = 0.5
static integer DURATION = 20
static integer DAMAGE_PER_SECOND = 20
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ALiS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Lightning Shield")
    call thistype.THIS_SPELL.SetOrder(OrderId("lightningshield"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 130)
    call thistype.THIS_SPELL.SetCooldown(1, 25)
    call thistype.THIS_SPELL.SetManaCost(1, 120)
    call thistype.THIS_SPELL.SetRange(1, 900)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNLightningShield.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act1\\LightningShield.page\\LightningShield.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod