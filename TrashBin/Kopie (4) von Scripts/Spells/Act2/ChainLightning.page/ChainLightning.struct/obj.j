//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ChainLightning.page\ChainLightning.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.CHEST"
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
static string EFFECT_LIGHTNING_PATH = "CLPB"
static integer TARGETS_AMOUNT = 6
static real DAMAGE_REDUCTION_FACTOR = 0.1
static string EFFECT_LIGHTNING2_PATH = "CLSB"
static integer DAMAGE = 120
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\ChainLightning.page\\ChainLightning.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AChL')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Chain Lightning")
    call thistype.THIS_SPELL.SetOrder(OrderId("chainlightning"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 500)
    call thistype.THIS_SPELL.SetCooldown(1, 15)
    call thistype.THIS_SPELL.SetManaCost(1, 95)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNChainLightning.blp")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Act2\\ChainLightning.page\\ChainLightning.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ChainLightning.page\ChainLightning.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod