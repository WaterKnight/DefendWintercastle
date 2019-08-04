static Spell THIS_SPELL
    
static string EFFECT_LIGHTNING_PATH = "CLPB"
static real array DAMAGE_REDUCTION_FACTOR
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
static integer array STUN_TARGETS_AMOUNT
static real array STUN_DURATION
static integer array TARGETS_AMOUNT
static string EFFECT_LIGHTNING2_PATH = "CLSB"
static integer array DAMAGE
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\LightningAttack.page\\LightningAttack.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ALiA')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(6)
    call thistype.THIS_SPELL.SetName("Lightning Attack")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetAreaRange(2, 500)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetAreaRange(3, 500)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetAreaRange(4, 500)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetAreaRange(5, 500)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetAreaRange(6, 500)
    call thistype.THIS_SPELL.SetRange(6, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp")
    
    set thistype.DAMAGE_REDUCTION_FACTOR[1] = 0.2
    set thistype.DAMAGE_REDUCTION_FACTOR[2] = 0.2
    set thistype.DAMAGE_REDUCTION_FACTOR[3] = 0.2
    set thistype.DAMAGE_REDUCTION_FACTOR[4] = 0.2
    set thistype.DAMAGE_REDUCTION_FACTOR[5] = 0.2
    set thistype.DAMAGE_REDUCTION_FACTOR[6] = 0.2
    set thistype.STUN_TARGETS_AMOUNT[1] = 2
    set thistype.STUN_TARGETS_AMOUNT[2] = 3
    set thistype.STUN_TARGETS_AMOUNT[3] = 3
    set thistype.STUN_TARGETS_AMOUNT[4] = 4
    set thistype.STUN_TARGETS_AMOUNT[5] = 4
    set thistype.STUN_TARGETS_AMOUNT[6] = 5
    set thistype.STUN_DURATION[1] = 1.25
    set thistype.STUN_DURATION[2] = 1.25
    set thistype.STUN_DURATION[3] = 1.25
    set thistype.STUN_DURATION[4] = 1.25
    set thistype.STUN_DURATION[5] = 1.25
    set thistype.STUN_DURATION[6] = 1.25
    set thistype.TARGETS_AMOUNT[1] = 10
    set thistype.TARGETS_AMOUNT[2] = 10
    set thistype.TARGETS_AMOUNT[3] = 10
    set thistype.TARGETS_AMOUNT[4] = 10
    set thistype.TARGETS_AMOUNT[5] = 10
    set thistype.TARGETS_AMOUNT[6] = 10
    set thistype.DAMAGE[1] = 20
    set thistype.DAMAGE[2] = 35
    set thistype.DAMAGE[3] = 50
    set thistype.DAMAGE[4] = 65
    set thistype.DAMAGE[5] = 80
    set thistype.DAMAGE[6] = 95
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\LightningAttack.page\\LightningAttack.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod