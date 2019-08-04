static Spell THIS_SPELL
    
static real INTERVAL = 0.25
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFyT')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Fairy's Tears")
    call thistype.THIS_SPELL.SetOrder(OrderId("starfall"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell,channel")
    call thistype.THIS_SPELL.SetAreaRange(1, 450)
    call thistype.THIS_SPELL.SetChannelTime(1, 80)
    call thistype.THIS_SPELL.SetCooldown(1, 24)
    call thistype.THIS_SPELL.SetManaCost(1, 250)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 525)
    call thistype.THIS_SPELL.SetChannelTime(2, 80)
    call thistype.THIS_SPELL.SetCooldown(2, 27)
    call thistype.THIS_SPELL.SetManaCost(2, 350)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 600)
    call thistype.THIS_SPELL.SetChannelTime(3, 80)
    call thistype.THIS_SPELL.SetCooldown(3, 30)
    call thistype.THIS_SPELL.SetManaCost(3, 450)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStarfall.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FFy0', 3, 'VFy0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\FairysTears.page\\FairysTears.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod