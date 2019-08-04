static Spell THIS_SPELL
    
static string SUMMON_EFFECT_PATH = "Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl"
static integer array MAX_TARGETS_AMOUNT
static real INTERVAL = 0.05
static integer array DURATION
static string SPECIAL_EFFECT_PATH = "Abilities\\Weapons\\TreantMissile\\TreantMissile.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AHoN')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_SECOND)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Hand of Nature")
    call thistype.THIS_SPELL.SetOrder(OrderId("entanglingroots"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 250)
    call thistype.THIS_SPELL.SetCooldown(1, 8)
    call thistype.THIS_SPELL.SetManaCost(1, 65)
    call thistype.THIS_SPELL.SetRange(1, 650)
    call thistype.THIS_SPELL.SetAreaRange(2, 250)
    call thistype.THIS_SPELL.SetCooldown(2, 8)
    call thistype.THIS_SPELL.SetManaCost(2, 75)
    call thistype.THIS_SPELL.SetRange(2, 650)
    call thistype.THIS_SPELL.SetAreaRange(3, 250)
    call thistype.THIS_SPELL.SetCooldown(3, 8)
    call thistype.THIS_SPELL.SetManaCost(3, 85)
    call thistype.THIS_SPELL.SetRange(3, 650)
    call thistype.THIS_SPELL.SetAreaRange(4, 250)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 95)
    call thistype.THIS_SPELL.SetRange(4, 650)
    call thistype.THIS_SPELL.SetAreaRange(5, 250)
    call thistype.THIS_SPELL.SetCooldown(5, 8)
    call thistype.THIS_SPELL.SetManaCost(5, 105)
    call thistype.THIS_SPELL.SetRange(5, 650)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNEntanglingRoots.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FHN0', 5, 'VHN0')
    
    set thistype.MAX_TARGETS_AMOUNT[1] = 2
    set thistype.MAX_TARGETS_AMOUNT[2] = 2
    set thistype.MAX_TARGETS_AMOUNT[3] = 2
    set thistype.MAX_TARGETS_AMOUNT[4] = 2
    set thistype.MAX_TARGETS_AMOUNT[5] = 2
    set thistype.DURATION[1] = 40
    set thistype.DURATION[2] = 40
    set thistype.DURATION[3] = 40
    set thistype.DURATION[4] = 40
    set thistype.DURATION[5] = 40
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\HandOfNature.page\\HandOfNature.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod