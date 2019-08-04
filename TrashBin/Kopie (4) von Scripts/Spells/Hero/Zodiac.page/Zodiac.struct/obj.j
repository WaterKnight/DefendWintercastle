//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static integer array HEAL
static integer HEAL_SPELL_POWER_MOD_FACTOR = 1
static integer array ARMOR_INCREMENT
static integer array DURATION
static real LIFE_REGEN_ADD = 0.75
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AZod')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Zodiac")
    call thistype.THIS_SPELL.SetOrder(OrderId("darkconversion"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 7)
    call thistype.THIS_SPELL.SetManaCost(1, 60)
    call thistype.THIS_SPELL.SetRange(1, 600)
    call thistype.THIS_SPELL.SetCooldown(2, 7)
    call thistype.THIS_SPELL.SetManaCost(2, 80)
    call thistype.THIS_SPELL.SetRange(2, 600)
    call thistype.THIS_SPELL.SetCooldown(3, 7)
    call thistype.THIS_SPELL.SetManaCost(3, 100)
    call thistype.THIS_SPELL.SetRange(3, 600)
    call thistype.THIS_SPELL.SetCooldown(4, 7)
    call thistype.THIS_SPELL.SetManaCost(4, 120)
    call thistype.THIS_SPELL.SetRange(4, 600)
    call thistype.THIS_SPELL.SetCooldown(5, 7)
    call thistype.THIS_SPELL.SetManaCost(5, 140)
    call thistype.THIS_SPELL.SetRange(5, 600)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRacoon.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FZo0', 5, 'VZo0')
    
    set thistype.HEAL[1] = 90
    set thistype.HEAL[2] = 165
    set thistype.HEAL[3] = 240
    set thistype.HEAL[4] = 315
    set thistype.HEAL[5] = 390
    set thistype.ARMOR_INCREMENT[1] = 4
    set thistype.ARMOR_INCREMENT[2] = 8
    set thistype.ARMOR_INCREMENT[3] = 12
    set thistype.ARMOR_INCREMENT[4] = 16
    set thistype.ARMOR_INCREMENT[5] = 20
    set thistype.DURATION[1] = 12
    set thistype.DURATION[2] = 15
    set thistype.DURATION[3] = 18
    set thistype.DURATION[4] = 21
    set thistype.DURATION[5] = 24
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BZoB', "Zodiac", 'bZoB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNRacoon.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Units\\NightElf\\Owl\\Owl.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Zodiac.page\\Zodiac.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod