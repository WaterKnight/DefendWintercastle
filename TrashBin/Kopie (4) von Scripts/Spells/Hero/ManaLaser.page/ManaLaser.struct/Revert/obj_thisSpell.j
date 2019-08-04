static Spell THIS_SPELL
    
static string SOURCE_EFFECT_PATH = "Spells\\ManaLaser\\Revert\\SourceEffect.mdx"
static integer DURATION = 5
static string CAST_END_EFFECT_PATH = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl"
static string CAST_EFFECT_PATH = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\Revert\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AMaR')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Revert")
    call thistype.THIS_SPELL.SetOrder(OrderId("darkconversion"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 0)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 0)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 0)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 0)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNNeutralManaShieldOff.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FMR0', 5, 'VMR0')
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\ManaLaser.page\\ManaLaser.struct\\Revert\\thisSpell.wc3spell")
    call t.Destroy()
endmethod