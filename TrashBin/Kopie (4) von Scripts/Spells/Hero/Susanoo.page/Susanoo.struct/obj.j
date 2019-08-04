//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\Susanoo.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static real array SPELL_POWER_INCREMENT
static integer array DURATION
static real array ATTACK_RATE_INCREMENT
static string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl"
static integer array DURATION_ADD
static string ADD_TIME_EFFECT_PATH = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
static string ADD_TIME_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static real array ARMOR_INCREMENT
static real DURATION_ADD_ADD_FACTOR = -0.3
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('ASus')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_ULTIMATE_EX)
    call thistype.THIS_SPELL.SetLevelsAmount(2)
    call thistype.THIS_SPELL.SetName("Susanoo")
    call thistype.THIS_SPELL.SetOrder(OrderId("manashieldon"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 60)
    call thistype.THIS_SPELL.SetManaCost(1, 110)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 60)
    call thistype.THIS_SPELL.SetManaCost(2, 170)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHowlOfTerror.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FSu0', 2, 'VSu0')
    
    set thistype.SPELL_POWER_INCREMENT[1] = 0.5
    set thistype.SPELL_POWER_INCREMENT[2] = 1
    set thistype.DURATION[1] = 12
    set thistype.DURATION[2] = 12
    set thistype.ATTACK_RATE_INCREMENT[1] = 0.35
    set thistype.ATTACK_RATE_INCREMENT[2] = 0.6
    set thistype.DURATION_ADD[1] = 2
    set thistype.DURATION_ADD[2] = 2
    set thistype.ARMOR_INCREMENT[1] = 0.35
    set thistype.ARMOR_INCREMENT[2] = 0.45
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\Susanoo.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\Susanoo.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.Create('BSuB', "Susanoo", 'bSuB')
    call thistype.DUMMY_BUFF.SetPositive(true)
    call thistype.DUMMY_BUFF.SetIcon("ReplaceableTextures\\CommandButtons\\BTNHowlOfTerror.blp")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Susanoo\\Buff.mdx", AttachPoint.OVERHEAD, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\Susanoo.page\\Susanoo.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\Susanoo.struct\obj_dummyBuff.j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
endmethod