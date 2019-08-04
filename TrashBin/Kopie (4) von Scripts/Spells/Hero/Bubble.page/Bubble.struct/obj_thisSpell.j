static Spell THIS_SPELL
    
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Bubble.page\\Bubble.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ABub')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Bubble")
    call thistype.THIS_SPELL.SetOrder(OrderId("voodoo"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 600)
    call thistype.THIS_SPELL.SetChannelTime(1, 10)
    call thistype.THIS_SPELL.SetCooldown(1, 90)
    call thistype.THIS_SPELL.SetManaCost(1, 250)
    call thistype.THIS_SPELL.SetRange(1, 675)
    call thistype.THIS_SPELL.SetAreaRange(2, 600)
    call thistype.THIS_SPELL.SetChannelTime(2, 13)
    call thistype.THIS_SPELL.SetCooldown(2, 80)
    call thistype.THIS_SPELL.SetManaCost(2, 250)
    call thistype.THIS_SPELL.SetRange(2, 675)
    call thistype.THIS_SPELL.SetAreaRange(3, 600)
    call thistype.THIS_SPELL.SetChannelTime(3, 16)
    call thistype.THIS_SPELL.SetCooldown(3, 70)
    call thistype.THIS_SPELL.SetManaCost(3, 250)
    call thistype.THIS_SPELL.SetRange(3, 675)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBigBadVoodooSpell.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FBu0', 3, 'VBu0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Bubble.page\\Bubble.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod