//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_thisSpell.j
static Spell THIS_SPELL
    
static string VICTIM_EFFECT_PATH = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl"
static string SUMMON_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
static real array DAMAGE_FACTOR
static integer array DURATION
static string DEATH_EFFECT_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
static string SUMMON_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
static integer array SUMMONS_AMOUNT
static string VICTIM_EFFECT_ATTACH_POINT = "AttachPoint.ORIGIN"
static integer array STOLEN_MANA
static integer SUMMON_OFFSET = 100
static string DEATH_EFFECT_ATTACH_POINT = "AttachPoint.WEAPON"
    
static method Init_obj_thisSpell takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\thisSpell.wc3spell")
    set thistype.THIS_SPELL = Spell.CreateFromSelf('AGhS')
    
    call thistype.THIS_SPELL.SetClass(SpellClass.PURCHASABLE)
    call thistype.THIS_SPELL.SetLevelsAmount(5)
    call thistype.THIS_SPELL.SetName("Ghost Sword")
    call thistype.THIS_SPELL.SetOrder(OrderId("summonwareagle"))
    call thistype.THIS_SPELL.SetTargetType(Spell.TARGET_TYPE_IMMEDIATE)
    call thistype.THIS_SPELL.SetAnimation("spell")
    call thistype.THIS_SPELL.SetCooldown(1, 12)
    call thistype.THIS_SPELL.SetManaCost(1, 40)
    call thistype.THIS_SPELL.SetRange(1, 750)
    call thistype.THIS_SPELL.SetCooldown(2, 12)
    call thistype.THIS_SPELL.SetManaCost(2, 50)
    call thistype.THIS_SPELL.SetRange(2, 750)
    call thistype.THIS_SPELL.SetCooldown(3, 12)
    call thistype.THIS_SPELL.SetManaCost(3, 60)
    call thistype.THIS_SPELL.SetRange(3, 750)
    call thistype.THIS_SPELL.SetCooldown(4, 12)
    call thistype.THIS_SPELL.SetManaCost(4, 70)
    call thistype.THIS_SPELL.SetRange(4, 750)
    call thistype.THIS_SPELL.SetCooldown(5, 12)
    call thistype.THIS_SPELL.SetManaCost(5, 80)
    call thistype.THIS_SPELL.SetRange(5, 750)
    call thistype.THIS_SPELL.SetIcon("ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
    
    call HeroSpell.InitSpell(thistype.THIS_SPELL, 'FGS0', 5, 'VGS0')
    
    set thistype.DAMAGE_FACTOR[1] = 1
    set thistype.DAMAGE_FACTOR[2] = 1.5
    set thistype.DAMAGE_FACTOR[3] = 2
    set thistype.DAMAGE_FACTOR[4] = 2.5
    set thistype.DAMAGE_FACTOR[5] = 3
    set thistype.DURATION[1] = 25
    set thistype.DURATION[2] = 25
    set thistype.DURATION[3] = 25
    set thistype.DURATION[4] = 25
    set thistype.DURATION[5] = 25
    set thistype.SUMMONS_AMOUNT[1] = 2
    set thistype.SUMMONS_AMOUNT[2] = 2
    set thistype.SUMMONS_AMOUNT[3] = 3
    set thistype.SUMMONS_AMOUNT[4] = 3
    set thistype.SUMMONS_AMOUNT[5] = 4
    set thistype.STOLEN_MANA[1] = 10
    set thistype.STOLEN_MANA[2] = 15
    set thistype.STOLEN_MANA[3] = 20
    set thistype.STOLEN_MANA[4] = 25
    set thistype.STOLEN_MANA[5] = 30
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\thisSpell.wc3spell")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_thisSpell.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[2].j

static method Init_obj_summonUnitType2 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[2].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[2] = UnitType.Create('uGh2')
    call thistype.SUMMON_UNIT_TYPE[2].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[2].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[2].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[2].Life.Set(275)
    call thistype.SUMMON_UNIT_TYPE[2].Life.SetBJ(275)
    call thistype.SUMMON_UNIT_TYPE[2].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[2].SpellPower.Set(40)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[2].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Set(5)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.SetBJ(5)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[2].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[2].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[2].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[2].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[1].j

static method Init_obj_summonUnitType1 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[1].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[1] = UnitType.Create('uGho')
    call thistype.SUMMON_UNIT_TYPE[1].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[1].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[1].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[1].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[1].Life.Set(200)
    call thistype.SUMMON_UNIT_TYPE[1].Life.SetBJ(200)
    call thistype.SUMMON_UNIT_TYPE[1].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[1].SpellPower.Set(40)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[1].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.SetBJ(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[1].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[1].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[1].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[1].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[3].j

static method Init_obj_summonUnitType3 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[3].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[3] = UnitType.Create('uGh3')
    call thistype.SUMMON_UNIT_TYPE[3].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[3].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[3].Life.Set(275)
    call thistype.SUMMON_UNIT_TYPE[3].Life.SetBJ(275)
    call thistype.SUMMON_UNIT_TYPE[3].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[3].SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[3].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Set(5)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.SetBJ(5)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[3].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[3].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[3].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[3].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_dummyBuff.j
static Buff DUMMY_BUFF
    
    
static method Init_obj_dummyBuff takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\dummyBuff.wc3buff")
    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME + " (dummyBuff)")
    call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\OrbOfDeath\\OrbOfDeathMissile.mdl", AttachPoint.WEAPON, EffectLevel.LOW)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\dummyBuff.wc3buff")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_dummyBuff.j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[5].j
static UnitType array SUMMON_UNIT_TYPE
    
    
static method Init_obj_summonUnitType5 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[5].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[5] = UnitType.Create('uGh5')
    call thistype.SUMMON_UNIT_TYPE[5].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[5].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[5].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[5].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[5].Life.Set(350)
    call thistype.SUMMON_UNIT_TYPE[5].Life.SetBJ(350)
    call thistype.SUMMON_UNIT_TYPE[5].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[5].SpellPower.Set(80)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[5].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Set(10)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.SetBJ(10)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[5].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[5].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[5].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[5].j

//open object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[4].j

static method Init_obj_summonUnitType4 takes nothing returns nothing
    local ObjThread t = ObjThread.Create("D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[4].wc3unit")
    set thistype.SUMMON_UNIT_TYPE[4] = UnitType.Create('uGh4')
    call thistype.SUMMON_UNIT_TYPE[4].Scale.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Impact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Outpact.Z.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Speed.Set(220)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Set(1)
    call thistype.SUMMON_UNIT_TYPE[4].Armor.Type.Set(Attack.ARMOR_TYPE_MEDIUM)
    call thistype.SUMMON_UNIT_TYPE[4].Life.Set(350)
    call thistype.SUMMON_UNIT_TYPE[4].Life.SetBJ(350)
    call thistype.SUMMON_UNIT_TYPE[4].LifeRegeneration.Set(0)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.Set(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SightRange.SetBJ(1400)
    call thistype.SUMMON_UNIT_TYPE[4].SpellPower.Set(60)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Set(Attack.NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Range.Set(128)
    call thistype.SUMMON_UNIT_TYPE[4].Attack.Speed.SetByCooldown(1.7)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Delay.Set(0.3)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Set(10)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.SetBJ(10)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Dices.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Sides.Set(2)
    call thistype.SUMMON_UNIT_TYPE[4].Damage.Type.Set(Attack.DMG_TYPE_NORMAL)
    call thistype.SUMMON_UNIT_TYPE[4].CollisionSize.Set(20)
    call DebugEx("init " + "D:\\Warcraft III\\Maps\\DWC\\Scripts\\Spells\\Purchasable\\GhostSword.page\\GhostSword.struct\\summonUnitType[4].wc3unit")
    call t.Destroy()
endmethod
//close object D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.struct\obj_summonUnitType[4].j


private static method onInit takes nothing returns nothing
    call Spell.AddInit(function thistype.Init_obj_thisSpell)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType2)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType1)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType3)
    call Buff.AddInit(function thistype.Init_obj_dummyBuff)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType5)
    call UnitType.AddInit(function thistype.Init_obj_summonUnitType4)
endmethod