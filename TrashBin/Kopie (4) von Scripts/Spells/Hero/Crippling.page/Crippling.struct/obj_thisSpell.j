static Spell THIS_SPELL
    
static real TARGET_CHANCE = 0.75
static string AREA_EFFECT_PATH = "Spells\\Crippling\\Area.mdx"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ACrp')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Crippling")
    call thistype.THIS_SPELL.SetOrder(OrderId("cripple"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 300)
    call thistype.THIS_SPELL.SetCooldown(1, 20)
    call thistype.THIS_SPELL.SetManaCost(1, 85)
    call thistype.THIS_SPELL.SetRange(1, 650)
    call thistype.THIS_SPELL.SetAreaRange(2, 300)
    call thistype.THIS_SPELL.SetCooldown(2, 18)
    call thistype.THIS_SPELL.SetManaCost(2, 110)
    call thistype.THIS_SPELL.SetRange(2, 650)
    call thistype.THIS_SPELL.SetAreaRange(3, 300)
    call thistype.THIS_SPELL.SetCooldown(3, 16)
    call thistype.THIS_SPELL.SetManaCost(3, 135)
    call thistype.THIS_SPELL.SetRange(3, 650)
    call thistype.THIS_SPELL.SetAreaRange(4, 300)
    call thistype.THIS_SPELL.SetCooldown(4, 14)
    call thistype.THIS_SPELL.SetManaCost(4, 160)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetAreaRange(5, 300)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 185)
    call thistype.THIS_SPELL.SetRange(5, 650)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FCp0', 5, 'VCp0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Crippling.page\\Crippling.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod