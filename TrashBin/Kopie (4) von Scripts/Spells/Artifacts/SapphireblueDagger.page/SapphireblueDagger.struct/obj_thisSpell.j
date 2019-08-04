static Spell THIS_SPELL
    
static string START_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
static string DAMAGE_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.HEAD"
static integer array BUFF_DURATION
static string HEAL_TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array LIFE_LEECH_INCREMENT
static integer array HEAL
static integer array MAX_RANGE
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
static string DAMAGE_TARGET_EFFECT_PATH = "none"
static integer array HEAL_PER_TARGET
static string HEAL_TARGET_EFFECT_PATH = "Abilities\\Spells\\Human\\\\Resurrect\\ResurrectTarget.mdl"
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\SapphireblueDagger.page\\SapphireblueDagger.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASaD')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.ARTIFACT)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Sapphireblue Dagger")
    call thistype.THIS_SPELL.SetOrder(OrderId("sanctuary"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_POINT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 200)
    call thistype.THIS_SPELL.SetCooldown(1, 11)
    call thistype.THIS_SPELL.SetManaCost(1, 30)
    call thistype.THIS_SPELL.SetRange(1, 99999)
    call thistype.THIS_SPELL.SetAreaRange(2, 200)
    call thistype.THIS_SPELL.SetCooldown(2, 11)
    call thistype.THIS_SPELL.SetManaCost(2, 30)
    call thistype.THIS_SPELL.SetRange(2, 99999)
    call thistype.THIS_SPELL.SetAreaRange(3, 200)
    call thistype.THIS_SPELL.SetCooldown(3, 11)
    call thistype.THIS_SPELL.SetManaCost(3, 30)
    call thistype.THIS_SPELL.SetRange(3, 99999)
    call thistype.THIS_SPELL.SetAreaRange(4, 200)
    call thistype.THIS_SPELL.SetCooldown(4, 11)
    call thistype.THIS_SPELL.SetManaCost(4, 30)
    call thistype.THIS_SPELL.SetRange(4, 99999)
    call thistype.THIS_SPELL.SetAreaRange(5, 200)
    call thistype.THIS_SPELL.SetCooldown(5, 11)
    call thistype.THIS_SPELL.SetManaCost(5, 30)
    call thistype.THIS_SPELL.SetRange(5, 99999)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNDaggerOfEscape.blp")
    
    set thistype.BUFF_DURATION[1] = 7
    set thistype.BUFF_DURATION[2] = 7
    set thistype.BUFF_DURATION[3] = 7
    set thistype.BUFF_DURATION[4] = 7
    set thistype.BUFF_DURATION[5] = 7
    set thistype.LIFE_LEECH_INCREMENT[1] = 3
    set thistype.LIFE_LEECH_INCREMENT[2] = 5
    set thistype.LIFE_LEECH_INCREMENT[3] = 7
    set thistype.LIFE_LEECH_INCREMENT[4] = 9
    set thistype.LIFE_LEECH_INCREMENT[5] = 12
    set thistype.HEAL[1] = 25
    set thistype.HEAL[2] = 36
    set thistype.HEAL[3] = 45
    set thistype.HEAL[4] = 52
    set thistype.HEAL[5] = 57
    set thistype.MAX_RANGE[1] = 500
    set thistype.MAX_RANGE[2] = 500
    set thistype.MAX_RANGE[3] = 500
    set thistype.MAX_RANGE[4] = 500
    set thistype.MAX_RANGE[5] = 500
    set thistype.HEAL_PER_TARGET[1] = 5
    set thistype.HEAL_PER_TARGET[2] = 6
    set thistype.HEAL_PER_TARGET[3] = 7
    set thistype.HEAL_PER_TARGET[4] = 8
    set thistype.HEAL_PER_TARGET[5] = 9
    set thistype.DAMAGE[1] = 0
    set thistype.DAMAGE[2] = 0
    set thistype.DAMAGE[3] = 0
    set thistype.DAMAGE[4] = 0
    set thistype.DAMAGE[5] = 0
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Artifacts\\SapphireblueDagger.page\\SapphireblueDagger.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod