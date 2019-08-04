//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_dummySpell.j
static Spell DUMMY_SPELL
    
    
static method Init_obj_dummySpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummySpell.wc3spell")
    set thistype.DUMMY_SPELL = Spell.CreateFromSelf('AFHD')
    
    call thistype.DUMMY_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.DUMMY_SPELL.SetLevelsAmount(1)
    call thistype.DUMMY_SPELL.SetName("Fountain Heal")
    call thistype.DUMMY_SPELL.SetAnimation("spell")
    call thistype.DUMMY_SPELL.SetRange(1, 384)
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummySpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_dummySpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_MANA_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static string TARGET_MANA_EFFECT_PATH = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
static string CASTER_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real HEAL_LIFE_PER_MANA_POINT = 1.5
static string CASTER_EFFECT_PATH = "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl"
static string TARGET_LIFE_EFFECT_PATH = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"
static string TARGET_LIFE_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real HEAL_MANA_PER_MANA_POINT = 1.5
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AFoH')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.NORMAL)
    call thistype.THIS_SPELL.SetLevelsAmount(1)
    call thistype.THIS_SPELL.SetName("Fountain Heal")
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetAreaRange(1, 0)
    call thistype.THIS_SPELL.SetRange(1, 0)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\")
    
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Misc\\FountainHeal.page\\FountainHeal.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_dummySpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod