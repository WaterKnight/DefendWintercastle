static Spell THIS_SPELL
    
static integer array ATTACK_DISABLE_DURATION
static integer array DAMAGE
static real array DAMAGE_FACTOR
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AWac')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Battle Rage")
    call thistype.THIS_SPELL.SetOrder(OrderId("roar"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 450)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 80)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 450)
    call thistype.THIS_SPELL.SetCooldown(2, 15)
    call thistype.THIS_SPELL.SetManaCost(2, 92)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 450)
    call thistype.THIS_SPELL.SetCooldown(3, 15)
    call thistype.THIS_SPELL.SetManaCost(3, 104)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetAreaRange(4, 450)
    call thistype.THIS_SPELL.SetCooldown(4, 15)
    call thistype.THIS_SPELL.SetManaCost(4, 116)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetAreaRange(5, 450)
    call thistype.THIS_SPELL.SetCooldown(5, 15)
    call thistype.THIS_SPELL.SetManaCost(5, 128)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FBR0', 5, 'VBR0')
    
    set thistype.ATTACK_DISABLE_DURATION[1] = 2
    set thistype.ATTACK_DISABLE_DURATION[2] = 2
    set thistype.ATTACK_DISABLE_DURATION[3] = 2
    set thistype.ATTACK_DISABLE_DURATION[4] = 2
    set thistype.ATTACK_DISABLE_DURATION[5] = 2
    set thistype.DAMAGE[1] = 35
    set thistype.DAMAGE[2] = 45
    set thistype.DAMAGE[3] = 55
    set thistype.DAMAGE[4] = 65
    set thistype.DAMAGE[5] = 75
    set thistype.DAMAGE_FACTOR[1] = 0.04
    set thistype.DAMAGE_FACTOR[2] = 0.05
    set thistype.DAMAGE_FACTOR[3] = 0.06
    set thistype.DAMAGE_FACTOR[4] = 0.07
    set thistype.DAMAGE_FACTOR[5] = 0.08
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\BattleRage.page\\BattleRage.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod