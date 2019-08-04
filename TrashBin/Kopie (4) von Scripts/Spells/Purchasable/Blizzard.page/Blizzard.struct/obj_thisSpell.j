static Spell THIS_SPELL
    
static real INTERVAL = 0.75
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Blizzard.page\\Blizzard.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABlz')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Blizzard")
    call thistype.THIS_SPELL.SetOrder(OrderId("blizzard"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 275)
    call thistype.THIS_SPELL.SetChannelTime(1, 5)
    call thistype.THIS_SPELL.SetCooldown(1, 0)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetAreaRange(2, 325)
    call thistype.THIS_SPELL.SetChannelTime(2, 5)
    call thistype.THIS_SPELL.SetCooldown(2, 0)
    call thistype.THIS_SPELL.SetManaCost(2, 55)
    call thistype.THIS_SPELL.SetRange(2, 600)
    call thistype.THIS_SPELL.SetAreaRange(3, 375)
    call thistype.THIS_SPELL.SetChannelTime(3, 5)
    call thistype.THIS_SPELL.SetCooldown(3, 0)
    call thistype.THIS_SPELL.SetManaCost(3, 70)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetAreaRange(4, 425)
    call thistype.THIS_SPELL.SetChannelTime(4, 5)
    call thistype.THIS_SPELL.SetCooldown(4, 0)
    call thistype.THIS_SPELL.SetManaCost(4, 85)
    call thistype.THIS_SPELL.SetRange(4, 600)
    call thistype.THIS_SPELL.SetAreaRange(5, 475)
    call thistype.THIS_SPELL.SetChannelTime(5, 5)
    call thistype.THIS_SPELL.SetCooldown(5, 0)
    call thistype.THIS_SPELL.SetManaCost(5, 100)
    call thistype.THIS_SPELL.SetRange(5, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FBl0', 5, 'VBl0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\Blizzard.page\\Blizzard.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod