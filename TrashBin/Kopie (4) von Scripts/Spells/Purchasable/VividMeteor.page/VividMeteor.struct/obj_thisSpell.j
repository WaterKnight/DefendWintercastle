static Spell THIS_SPELL
    
static integer array HEAL
static integer array POISON_DURATION
static integer array DAMAGE
static real DELAY = 1.5
static string SPECIAL_EFFECT_PATH = "Units\\Demon\\Infernal\\InfernalBirth.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\VividMeteor.page\\VividMeteor.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AViM')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Vivid Meteor")
    call thistype.THIS_SPELL.SetOrder(OrderId("monsoon"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 300)
    call thistype.THIS_SPELL.SetCooldown(1, 10)
    call thistype.THIS_SPELL.SetManaCost(1, 80)
    call thistype.THIS_SPELL.SetRange(1, 1400)
    call thistype.THIS_SPELL.SetAreaRange(2, 300)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 100)
    call thistype.THIS_SPELL.SetRange(2, 1400)
    call thistype.THIS_SPELL.SetAreaRange(3, 300)
    call thistype.THIS_SPELL.SetCooldown(3, 10)
    call thistype.THIS_SPELL.SetManaCost(3, 120)
    call thistype.THIS_SPELL.SetRange(3, 1400)
    call thistype.THIS_SPELL.SetAreaRange(4, 300)
    call thistype.THIS_SPELL.SetCooldown(4, 10)
    call thistype.THIS_SPELL.SetManaCost(4, 140)
    call thistype.THIS_SPELL.SetRange(4, 1400)
    call thistype.THIS_SPELL.SetAreaRange(5, 300)
    call thistype.THIS_SPELL.SetCooldown(5, 10)
    call thistype.THIS_SPELL.SetManaCost(5, 160)
    call thistype.THIS_SPELL.SetRange(5, 1400)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNFireRocks.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FVi0', 5, 'VVi0')
    
    set thistype.HEAL[1] = 125
    set thistype.HEAL[2] = 200
    set thistype.HEAL[3] = 275
    set thistype.HEAL[4] = 350
    set thistype.HEAL[5] = 425
    set thistype.POISON_DURATION[1] = 3
    set thistype.POISON_DURATION[2] = 4
    set thistype.POISON_DURATION[3] = 5
    set thistype.POISON_DURATION[4] = 6
    set thistype.POISON_DURATION[5] = 7
    set thistype.DAMAGE[1] = 65
    set thistype.DAMAGE[2] = 105
    set thistype.DAMAGE[3] = 145
    set thistype.DAMAGE[4] = 185
    set thistype.DAMAGE[5] = 225
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\VividMeteor.page\\VividMeteor.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod