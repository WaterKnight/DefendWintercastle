//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string TARGET_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array DAMAGE
static integer array HEAL
static integer SILENCE_DURATION = 3
static string TARGET_EFFECT_PATH = "Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl"
static integer SPEED = 1000
static integer array HEAL_SPELL_POWER_MOD_FACTOR
static integer EFFECT_CASTER_AMOUNT = 2
static integer HIT_RANGE = 120
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AEmB')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.HERO_FIRST)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Emphatic Bite")
    call thistype.THIS_SPELL.SetOrder(OrderId("cannibalize"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_UNIT)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 11)
    call thistype.THIS_SPELL.SetManaCost(1, 75)
    call thistype.THIS_SPELL.SetRange(1, 550)
    call thistype.THIS_SPELL.SetCooldown(2, 10)
    call thistype.THIS_SPELL.SetManaCost(2, 85)
    call thistype.THIS_SPELL.SetRange(2, 550)
    call thistype.THIS_SPELL.SetCooldown(3, 9)
    call thistype.THIS_SPELL.SetManaCost(3, 100)
    call thistype.THIS_SPELL.SetRange(3, 550)
    call thistype.THIS_SPELL.SetCooldown(4, 8)
    call thistype.THIS_SPELL.SetManaCost(4, 115)
    call thistype.THIS_SPELL.SetRange(4, 550)
    call thistype.THIS_SPELL.SetCooldown(5, 7)
    call thistype.THIS_SPELL.SetManaCost(5, 130)
    call thistype.THIS_SPELL.SetRange(5, 550)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNCannibalize.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FEB0', 5, 'VEB0')
    
    set thistype.DAMAGE[1] = 45
    set thistype.DAMAGE[2] = 65
    set thistype.DAMAGE[3] = 90
    set thistype.DAMAGE[4] = 120
    set thistype.DAMAGE[5] = 155
    set thistype.HEAL[1] = 45
    set thistype.HEAL[2] = 65
    set thistype.HEAL[3] = 90
    set thistype.HEAL[4] = 120
    set thistype.HEAL[5] = 155
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[1] = 1
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[2] = 1
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[3] = 1
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[4] = 1
    set thistype.HEAL_SPELL_POWER_MOD_FACTOR[5] = 1
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Hero\\EmphaticBite.page\\EmphaticBite.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\obj_thisSpell.j


private static method onInit takes nothing returns nothing
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
endmethod