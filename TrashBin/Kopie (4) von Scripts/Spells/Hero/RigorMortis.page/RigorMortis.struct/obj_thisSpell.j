static Spell THIS_SPELL
    
static real array LIFE_FACTOR
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl"
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real array MANA_FACTOR
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
static integer DELAY = 4
static integer INVISIBILITY_DURATION = 5
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RigorMortis.page\\RigorMortis.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ARig')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE)
    call thistype.THIS_SPELL.SetLevelsAmount(3)
    call thistype.THIS_SPELL.SetName("Rigor Mortis")
    call thistype.THIS_SPELL.SetOrder(OrderId("rejuvination"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 70)
    call thistype.THIS_SPELL.SetManaCost(1, 100)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 60)
    call thistype.THIS_SPELL.SetManaCost(2, 150)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 50)
    call thistype.THIS_SPELL.SetManaCost(3, 200)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FRe0', 3, 'VRe0')
    
    set thistype.LIFE_FACTOR[1] = 0.3
    set thistype.LIFE_FACTOR[2] = 0.5
    set thistype.LIFE_FACTOR[3] = 0.7
    set thistype.MANA_FACTOR[1] = 0.3
    set thistype.MANA_FACTOR[2] = 0.5
    set thistype.MANA_FACTOR[3] = 0.7
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\RigorMortis.page\\RigorMortis.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod